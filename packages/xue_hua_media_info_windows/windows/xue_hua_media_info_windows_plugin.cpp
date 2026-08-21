#include "xue_hua_media_info_windows_plugin.h"

#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <objidl.h>
#include <shlwapi.h>
#include <wincodec.h>
#include <windows.h>
#include <wrl/client.h>

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iterator>
#include <map>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

#pragma comment(lib, "windowscodecs.lib")
#pragma comment(lib, "mfplat.lib")
#pragma comment(lib, "mfreadwrite.lib")
#pragma comment(lib, "mfuuid.lib")
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "shlwapi.lib")

using Microsoft::WRL::ComPtr;

namespace xue_hua_media_info_windows {
namespace {

class MediaException : public std::runtime_error {
 public:
  MediaException(std::string code, std::string message)
      : std::runtime_error(std::move(message)), code_(std::move(code)) {}
  const std::string& code() const { return code_; }

 private:
  std::string code_;
};

[[noreturn]] void Fail(const char* code, const std::string& message) {
  throw MediaException(code, message);
}

std::string WideToUtf8(const std::wstring& wide) {
  if (wide.empty()) {
    return {};
  }
  const int length = WideCharToMultiByte(CP_UTF8, 0, wide.data(),
                                         static_cast<int>(wide.size()), nullptr,
                                         0, nullptr, nullptr);
  std::string utf8(length, '\0');
  WideCharToMultiByte(CP_UTF8, 0, wide.data(), static_cast<int>(wide.size()),
                      utf8.data(), length, nullptr, nullptr);
  return utf8;
}

std::wstring Utf8ToWide(const std::string& utf8) {
  if (utf8.empty()) {
    return {};
  }
  const int length = MultiByteToWideChar(CP_UTF8, 0, utf8.data(),
                                         static_cast<int>(utf8.size()), nullptr,
                                         0);
  std::wstring wide(length, L'\0');
  MultiByteToWideChar(CP_UTF8, 0, utf8.data(), static_cast<int>(utf8.size()),
                      wide.data(), length);
  return wide;
}

uint32_t Be32(const uint8_t* p) {
  return (uint32_t(p[0]) << 24) | (uint32_t(p[1]) << 16) | (uint32_t(p[2]) << 8) |
         uint32_t(p[3]);
}

struct ImageFields {
  std::optional<std::string> make;
  std::optional<std::string> model;
  std::optional<std::string> software;
  std::optional<int64_t> width;
  std::optional<int64_t> height;
  std::optional<int64_t> orientation;
  std::optional<std::string> date_original;
  std::optional<std::string> date_digitized;
  std::optional<std::string> date_modified;
  std::optional<double> lat;
  std::optional<double> lng;
  std::optional<double> alt;
  bool has_motion_photo = false;
  std::vector<std::pair<std::string, std::string>> png_text;
};

int32_t FindAscii(const std::vector<uint8_t>& data, const char* needle,
                  size_t from) {
  const size_t n = strlen(needle);
  if (n == 0 || data.size() < n) {
    return -1;
  }
  for (size_t i = from; i + n <= data.size(); ++i) {
    if (memcmp(data.data() + i, needle, n) == 0) {
      return static_cast<int32_t>(i);
    }
  }
  return -1;
}

std::optional<int64_t> OffsetFromXmpLength(const std::string& xmp, size_t data_size,
                                           const char* pattern) {
  const auto pos = xmp.find(pattern);
  if (pos == std::string::npos) {
    return std::nullopt;
  }
  size_t i = pos + strlen(pattern);
  while (i < xmp.size() && (xmp[i] == '"' || xmp[i] == '>' || xmp[i] == '=' ||
                            xmp[i] == ' ' || xmp[i] == '\t')) {
    ++i;
  }
  size_t start = i;
  while (i < xmp.size() && xmp[i] >= '0' && xmp[i] <= '9') {
    ++i;
  }
  if (i == start) {
    return std::nullopt;
  }
  try {
    const int from_end = std::stoi(xmp.substr(start, i - start));
    const int64_t off = static_cast<int64_t>(data_size) - from_end;
    if (off > 0 && off < static_cast<int64_t>(data_size)) {
      return off;
    }
  } catch (...) {
  }
  return std::nullopt;
}

std::optional<int64_t> MotionPhotoOffset(const std::vector<uint8_t>& data) {
  const int32_t xmp_start = FindAscii(data, "<x:xmpmeta", 0);
  if (xmp_start < 0) {
    return std::nullopt;
  }
  const int32_t xmp_end = FindAscii(data, "</x:xmpmeta>", static_cast<size_t>(xmp_start));
  if (xmp_end < 0) {
    return std::nullopt;
  }
  const std::string xmp(data.begin() + xmp_start,
                        data.begin() + xmp_end + static_cast<int32_t>(strlen("</x:xmpmeta>")));
  if (auto off = OffsetFromXmpLength(xmp, data.size(), "GCamera:MicroVideoOffset")) {
    return off;
  }
  if (auto off = OffsetFromXmpLength(xmp, data.size(), "MicroVideoOffset")) {
    return off;
  }
  const bool is_motion =
      xmp.find("MotionPhoto") != std::string::npos ||
      xmp.find("MicroVideo") != std::string::npos;
  if (!is_motion) {
    return std::nullopt;
  }
  std::optional<int64_t> last;
  size_t search = 0;
  while (true) {
    const auto pos = xmp.find("Item:Length", search);
    if (pos == std::string::npos) {
      break;
    }
    last = OffsetFromXmpLength(xmp.substr(pos), data.size(), "Item:Length");
    search = pos + 11;
  }
  return last;
}

void ParsePng(const std::vector<uint8_t>& data, ImageFields* out) {
  if (data.size() < 8 || data[0] != 0x89 || data[1] != 0x50) {
    return;
  }
  size_t offset = 8;
  while (offset + 12 <= data.size()) {
    const uint32_t length = Be32(data.data() + offset);
    if (offset + 12 + length > data.size()) {
      break;
    }
    const std::string type(reinterpret_cast<const char*>(data.data() + offset + 4),
                           4);
    if (type == "IHDR" && length >= 8) {
      out->width = Be32(data.data() + offset + 8);
      out->height = Be32(data.data() + offset + 12);
    } else if (type == "tEXt") {
      const uint8_t* payload = data.data() + offset + 8;
      size_t split = 0;
      while (split < length && payload[split] != 0) {
        ++split;
      }
      if (split > 0 && split < length) {
        out->png_text.emplace_back(
            std::string(reinterpret_cast<const char*>(payload), split),
            std::string(reinterpret_cast<const char*>(payload + split + 1),
                        length - split - 1));
      }
    }
    if (type == "IEND") {
      break;
    }
    offset += 12 + length;
  }
}

uint16_t U16(const uint8_t* p, bool little) {
  return little ? uint16_t(p[0] | (p[1] << 8)) : uint16_t((p[0] << 8) | p[1]);
}
uint32_t U32(const uint8_t* p, bool little) {
  return little ? p[0] | (p[1] << 8) | (p[2] << 16) | (p[3] << 24)
                : (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3];
}

struct TiffEntry {
  uint16_t type = 0;
  uint32_t count = 0;
  const uint8_t* value = nullptr;
};

void ReadIfd(const uint8_t* base, size_t size, uint32_t offset, bool little,
             std::map<uint16_t, TiffEntry>* entries) {
  if (offset + 2 > size) {
    return;
  }
  const uint16_t count = U16(base + offset, little);
  uint32_t cursor = offset + 2;
  for (uint16_t i = 0; i < count; ++i) {
    if (cursor + 12 > size) {
      break;
    }
    const uint16_t tag = U16(base + cursor, little);
    TiffEntry entry;
    entry.type = U16(base + cursor + 2, little);
    entry.count = U32(base + cursor + 4, little);
    entry.value = base + cursor + 8;
    (*entries)[tag] = entry;
    cursor += 12;
  }
}

const uint8_t* EntryPayload(const uint8_t* base, size_t size, const TiffEntry& e,
                            bool little, size_t* out_size) {
  size_t unit = 1;
  if (e.type == 3) unit = 2;
  if (e.type == 4) unit = 4;
  if (e.type == 5 || e.type == 10) unit = 8;
  *out_size = unit * e.count;
  if (*out_size <= 4) {
    return e.value;
  }
  const uint32_t off = U32(e.value, little);
  if (off + *out_size > size) {
    *out_size = 0;
    return nullptr;
  }
  return base + off;
}

std::optional<std::string> EntryAscii(const uint8_t* base, size_t size,
                                      const std::map<uint16_t, TiffEntry>& entries,
                                      uint16_t tag, bool little) {
  const auto it = entries.find(tag);
  if (it == entries.end() || it->second.type != 2) {
    return std::nullopt;
  }
  size_t n = 0;
  const uint8_t* p = EntryPayload(base, size, it->second, little, &n);
  if (!p || n == 0) {
    return std::nullopt;
  }
  while (n > 0 && p[n - 1] == 0) {
    --n;
  }
  if (n == 0) {
    return std::nullopt;
  }
  return std::string(reinterpret_cast<const char*>(p), n);
}

void ParseJpegExif(const std::vector<uint8_t>& data, ImageFields* out) {
  size_t offset = 2;
  while (offset + 4 <= data.size() && data[offset] == 0xFF) {
    const uint8_t marker = data[offset + 1];
    if (marker == 0xDA || marker == 0xD9) {
      break;
    }
    if (marker >= 0xD0 && marker <= 0xD7) {
      offset += 2;
      continue;
    }
    const uint16_t length = (data[offset + 2] << 8) | data[offset + 3];
    if (length < 2 || offset + 2 + length > data.size()) {
      break;
    }
    const uint8_t* payload = data.data() + offset + 4;
    const size_t payload_size = length - 2;
    if ((marker >= 0xC0 && marker <= 0xC3) && payload_size >= 5) {
      out->height = (payload[1] << 8) | payload[2];
      out->width = (payload[3] << 8) | payload[4];
    }
    if (marker == 0xE1 && payload_size >= 14 && memcmp(payload, "Exif\0\0", 6) == 0) {
      const uint8_t* tiff = payload + 6;
      const size_t tiff_size = payload_size - 6;
      const bool little = tiff[0] == 0x49;
      if (U16(tiff + 2, little) == 42) {
        std::map<uint16_t, TiffEntry> ifd0;
        ReadIfd(tiff, tiff_size, U32(tiff + 4, little), little, &ifd0);
        out->make = EntryAscii(tiff, tiff_size, ifd0, 0x010F, little);
        out->model = EntryAscii(tiff, tiff_size, ifd0, 0x0110, little);
        out->software = EntryAscii(tiff, tiff_size, ifd0, 0x0131, little);
        out->date_modified = EntryAscii(tiff, tiff_size, ifd0, 0x0132, little);
        const auto ori = ifd0.find(0x0112);
        if (ori != ifd0.end()) {
          size_t n = 0;
          const uint8_t* p = EntryPayload(tiff, tiff_size, ori->second, little, &n);
          if (p && n >= 2) {
            out->orientation = U16(p, little);
          }
        }
        auto read_sub = [&](uint16_t tag, std::map<uint16_t, TiffEntry>* dest) {
          const auto it = ifd0.find(tag);
          if (it == ifd0.end()) {
            return;
          }
          size_t n = 0;
          const uint8_t* p = EntryPayload(tiff, tiff_size, it->second, little, &n);
          if (p && n >= 4) {
            ReadIfd(tiff, tiff_size, U32(it->second.value, little), little, dest);
          }
        };
        std::map<uint16_t, TiffEntry> exif;
        read_sub(0x8769, &exif);
        out->date_original = EntryAscii(tiff, tiff_size, exif, 0x9003, little);
        out->date_digitized = EntryAscii(tiff, tiff_size, exif, 0x9004, little);
        std::map<uint16_t, TiffEntry> gps;
        read_sub(0x8825, &gps);
        auto rational3 = [&](uint16_t tag) -> std::optional<double> {
          const auto it = gps.find(tag);
          if (it == gps.end()) {
            return std::nullopt;
          }
          size_t n = 0;
          const uint8_t* p = EntryPayload(tiff, tiff_size, it->second, little, &n);
          if (!p || n < 24) {
            return std::nullopt;
          }
          auto rat = [&](int i) {
            const uint32_t num = U32(p + i * 8, little);
            const uint32_t den = U32(p + i * 8 + 4, little);
            return den == 0 ? 0.0 : double(num) / double(den);
          };
          return rat(0) + rat(1) / 60.0 + rat(2) / 3600.0;
        };
        auto lat = rational3(0x0002);
        auto lng = rational3(0x0004);
        auto lat_ref = EntryAscii(tiff, tiff_size, gps, 0x0001, little);
        auto lng_ref = EntryAscii(tiff, tiff_size, gps, 0x0003, little);
        if (lat && lng) {
          if (lat_ref && *lat_ref == "S") {
            *lat = -*lat;
          }
          if (lng_ref && *lng_ref == "W") {
            *lng = -*lng;
          }
          out->lat = lat;
          out->lng = lng;
          auto rational1 = [&](uint16_t tag) -> std::optional<double> {
            const auto it = gps.find(tag);
            if (it == gps.end()) {
              return std::nullopt;
            }
            size_t n = 0;
            const uint8_t* p = EntryPayload(tiff, tiff_size, it->second, little, &n);
            if (!p || n < 8) {
              return std::nullopt;
            }
            const uint32_t num = U32(p, little);
            const uint32_t den = U32(p + 4, little);
            return den == 0 ? 0.0 : double(num) / double(den);
          };
          auto alt = rational1(0x0006);
          if (alt) {
            const auto ref = gps.find(0x0005);
            if (ref != gps.end()) {
              size_t n = 0;
              const uint8_t* p =
                  EntryPayload(tiff, tiff_size, ref->second, little, &n);
              if (p && n >= 1 && p[0] == 1) {
                *alt = -*alt;
              }
            }
            out->alt = alt;
          }
        }
      }
    }
    offset += 2 + length;
  }
}

bool EndsWith(const std::string& value, const char* suffix) {
  const size_t n = strlen(suffix);
  return value.size() >= n && value.compare(value.size() - n, n, suffix) == 0;
}

MediaKindMessage Sniff(const std::vector<uint8_t>& prefix, const std::string* uri) {
  const std::string name = uri ? *uri : "";
  std::string lower = name;
  for (char& c : lower) {
    c = static_cast<char>(tolower(static_cast<unsigned char>(c)));
  }
  if (EndsWith(lower, ".raf") || EndsWith(lower, ".cr3") || EndsWith(lower, ".iiq")) {
    Fail("unsupportedFormat", "RAW formats are not supported.");
  }
  if (prefix.size() >= 15 &&
      memcmp(prefix.data(), "FUJIFILMCCD-RAW", 15) == 0) {
    Fail("unsupportedFormat", "Fujifilm RAF is not supported.");
  }
  if (prefix.size() >= 3 && prefix[0] == 0xFF && prefix[1] == 0xD8) {
    return MediaKindMessage::kImage;
  }
  if (prefix.size() >= 8 && prefix[0] == 0x89 && prefix[1] == 0x50 &&
      prefix[2] == 0x4E && prefix[3] == 0x47) {
    return MediaKindMessage::kImage;
  }
  if (prefix.size() >= 4 &&
      ((prefix[0] == 0x49 && prefix[1] == 0x49) ||
       (prefix[0] == 0x4D && prefix[1] == 0x4D))) {
    if (FindAscii(prefix, "IIQ", 0) >= 0 ||
        FindAscii(prefix, "Phase One", 0) >= 0) {
      Fail("unsupportedFormat", "Phase One IIQ is not supported.");
    }
    return MediaKindMessage::kImage;
  }
  if (prefix.size() >= 12 && memcmp(prefix.data() + 4, "ftyp", 4) == 0) {
    const std::string brand(reinterpret_cast<const char*>(prefix.data() + 8), 4);
    if (brand.rfind("crx", 0) == 0) {
      Fail("unsupportedFormat", "Canon CR3 is not supported.");
    }
    if (brand == "heic" || brand == "heif" || brand == "mif1" || brand == "msf1" ||
        brand == "avif" || brand == "avis") {
      return MediaKindMessage::kImage;
    }
    return MediaKindMessage::kVideo;
  }
  if (prefix.size() >= 4 && prefix[0] == 0x1A && prefix[1] == 0x45 &&
      prefix[2] == 0xDF && prefix[3] == 0xA3) {
    return MediaKindMessage::kVideo;
  }
  if (EndsWith(lower, ".m4a") || EndsWith(lower, ".aac") ||
      EndsWith(lower, ".mp3") || EndsWith(lower, ".wav")) {
    return MediaKindMessage::kAudio;
  }
  Fail("unsupportedFormat", "Unrecognized media header.");
  return MediaKindMessage::kVideo;
}

constexpr size_t kHeaderBytes = 256;

std::wstring AssetFullPath(const std::wstring& assets_dir, const std::string& uri) {
  std::wstring path = assets_dir + L"\\" + Utf8ToWide(uri);
  for (auto& c : path) {
    if (c == L'/') {
      c = L'\\';
    }
  }
  return path;
}

std::vector<uint8_t> ReadFileBytes(const std::wstring& path) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    Fail("notFound", "File not found.");
  }
  return std::vector<uint8_t>(std::istreambuf_iterator<char>(in),
                              std::istreambuf_iterator<char>());
}

std::vector<uint8_t> ReadFilePrefix(const std::wstring& path, size_t count) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    Fail("notFound", "File not found.");
  }
  std::vector<uint8_t> buffer(count);
  in.read(reinterpret_cast<char*>(buffer.data()),
          static_cast<std::streamsize>(count));
  buffer.resize(static_cast<size_t>(std::max<std::streamsize>(0, in.gcount())));
  return buffer;
}

std::vector<uint8_t> LoadBytes(const MediaSourceMessage& source,
                               const std::wstring& assets_dir) {
  switch (source.kind()) {
    case SourceKindMessage::kFile: {
      if (!source.uri()) {
        Fail("notFound", "Missing path.");
      }
      return ReadFileBytes(Utf8ToWide(*source.uri()));
    }
    case SourceKindMessage::kBytes: {
      if (!source.bytes()) {
        Fail("notFound", "Missing byte payload.");
      }
      return *source.bytes();
    }
    case SourceKindMessage::kAsset: {
      if (!source.uri()) {
        Fail("notFound", "Missing asset key.");
      }
      return ReadFileBytes(AssetFullPath(assets_dir, *source.uri()));
    }
  }
  Fail("unsupported", "Unknown source kind.");
}

std::vector<uint8_t> LoadPrefix(const MediaSourceMessage& source,
                                const std::wstring& assets_dir, size_t count) {
  switch (source.kind()) {
    case SourceKindMessage::kFile: {
      if (!source.uri()) {
        Fail("notFound", "Missing path.");
      }
      return ReadFilePrefix(Utf8ToWide(*source.uri()), count);
    }
    case SourceKindMessage::kBytes: {
      if (!source.bytes()) {
        Fail("notFound", "Missing byte payload.");
      }
      const auto& data = *source.bytes();
      const size_t n = std::min(count, data.size());
      return std::vector<uint8_t>(data.begin(), data.begin() + static_cast<std::ptrdiff_t>(n));
    }
    case SourceKindMessage::kAsset: {
      if (!source.uri()) {
        Fail("notFound", "Missing asset key.");
      }
      return ReadFilePrefix(AssetFullPath(assets_dir, *source.uri()), count);
    }
  }
  Fail("unsupported", "Unknown source kind.");
}

std::optional<std::string> QueryString(IWICMetadataQueryReader* reader,
                                       const wchar_t* path) {
  PROPVARIANT var;
  PropVariantInit(&var);
  const HRESULT hr = reader->GetMetadataByName(path, &var);
  std::optional<std::string> result;
  if (SUCCEEDED(hr)) {
    if (var.vt == VT_LPSTR && var.pszVal) {
      result = var.pszVal;
    } else if (var.vt == VT_LPWSTR && var.pwszVal) {
      result = WideToUtf8(var.pwszVal);
    }
  }
  PropVariantClear(&var);
  return result;
}

ImageMetadataMessage ReadImage(const std::vector<uint8_t>& data) {
  ImageFields fields;
  if (data.size() >= 3 && data[0] == 0xFF && data[1] == 0xD8) {
    ParseJpegExif(data, &fields);
  }
  ParsePng(data, &fields);
  fields.has_motion_photo = MotionPhotoOffset(data).has_value();

  ComPtr<IWICImagingFactory> factory;
  if (SUCCEEDED(CoCreateInstance(CLSID_WICImagingFactory, nullptr, CLSCTX_INPROC_SERVER,
                                 IID_PPV_ARGS(&factory)))) {
    ComPtr<IStream> stream;
    stream.Attach(SHCreateMemStream(data.data(), static_cast<UINT>(data.size())));
    if (stream) {
      ComPtr<IWICBitmapDecoder> decoder;
      if (SUCCEEDED(factory->CreateDecoderFromStream(
              stream.Get(), nullptr, WICDecodeMetadataCacheOnDemand, &decoder))) {
        ComPtr<IWICBitmapFrameDecode> frame;
        if (SUCCEEDED(decoder->GetFrame(0, &frame))) {
          UINT w = 0, h = 0;
          if (SUCCEEDED(frame->GetSize(&w, &h)) && w > 0 && h > 0) {
            fields.width = w;
            fields.height = h;
          }
          ComPtr<IWICMetadataQueryReader> reader;
          if (SUCCEEDED(frame->GetMetadataQueryReader(&reader))) {
            if (!fields.make) {
              fields.make = QueryString(reader.Get(), L"/app1/ifd/{ushort=271}");
            }
            if (!fields.model) {
              fields.model = QueryString(reader.Get(), L"/app1/ifd/{ushort=272}");
            }
            if (!fields.software) {
              fields.software =
                  QueryString(reader.Get(), L"/app1/ifd/{ushort=305}");
            }
          }
        }
      } else if (!fields.width) {
        Fail("unsupportedFormat", "WIC could not decode this image.");
      }
    }
  }

  ImageMetadataMessage image(fields.has_motion_photo, flutter::EncodableList{},
                             flutter::EncodableList{});
  if (fields.make) image.set_make(*fields.make);
  if (fields.model) image.set_model(*fields.model);
  if (fields.software) image.set_software(*fields.software);
  if (fields.width && fields.height) {
    image.set_size(PixelSizeMessage(*fields.width, *fields.height));
  }
  if (fields.orientation) image.set_orientation(*fields.orientation);
  if (fields.date_original) image.set_date_time_original(*fields.date_original);
  if (fields.date_digitized) image.set_date_time_digitized(*fields.date_digitized);
  if (fields.date_modified) image.set_date_time_modified(*fields.date_modified);
  if (fields.lat && fields.lng) {
    if (fields.alt) {
      const double alt = *fields.alt;
      image.set_gps(GpsLocationMessage(*fields.lat, *fields.lng, &alt));
    } else {
      image.set_gps(GpsLocationMessage(*fields.lat, *fields.lng));
    }
  }
  flutter::EncodableList png_text;
  for (const auto& chunk : fields.png_text) {
    png_text.push_back(flutter::EncodableValue(
        flutter::CustomEncodableValue(PngTextChunkMessage(chunk.first, chunk.second))));
  }
  image.set_png_text(png_text);
  return image;
}

constexpr uint32_t FourCC(char a, char b, char c, char d) {
  return (uint32_t(uint8_t(a)) << 24) | (uint32_t(uint8_t(b)) << 16) |
         (uint32_t(uint8_t(c)) << 8) | uint32_t(uint8_t(d));
}

struct AvExtras {
  std::optional<std::string> make;
  std::optional<std::string> model;
  std::optional<double> lat;
  std::optional<double> lng;
  std::optional<double> alt;
  std::optional<int64_t> rotation;
};

void ParseIso6709Into(const std::string& raw, AvExtras* extras) {
  size_t i = 0;
  auto parse_num = [&](double* out) -> bool {
    if (i >= raw.size() || (raw[i] != '+' && raw[i] != '-')) {
      return false;
    }
    const size_t start = i++;
    while (i < raw.size() && (std::isdigit(static_cast<unsigned char>(raw[i])) ||
                              raw[i] == '.')) {
      ++i;
    }
    if (i == start + 1) {
      return false;
    }
    try {
      *out = std::stod(raw.substr(start, i - start));
    } catch (...) {
      return false;
    }
    return true;
  };
  double lat = 0, lng = 0, alt = 0;
  if (!parse_num(&lat) || !parse_num(&lng)) {
    return;
  }
  extras->lat = lat;
  extras->lng = lng;
  if (parse_num(&alt)) {
    extras->alt = alt;
  }
}

void AssignUserData(uint32_t key, std::string text, AvExtras* extras) {
  while (!text.empty() && (text.back() == 0 || text.back() == ' ')) {
    text.pop_back();
  }
  if (text.empty()) {
    return;
  }
  if (key == 0xA96D616B) {  // ©mak
    extras->make = text;
  } else if (key == 0xA96D6F64) {  // ©mod
    extras->model = text;
  } else if (key == 0xA978797A) {  // ©xyz
    ParseIso6709Into(text, extras);
  }
}

void ParseTkhd(const uint8_t* p, size_t n, AvExtras* extras) {
  if (n < 84) {
    return;
  }
  const uint8_t version = p[0];
  const size_t matrix_off = version == 1 ? 52 : 40;
  if (matrix_off + 44 > n) {
    return;
  }
  const uint32_t width = Be32(p + matrix_off + 36) >> 16;
  const uint32_t height = Be32(p + matrix_off + 40) >> 16;
  if (width == 0 || height == 0) {
    return;
  }
  const int32_t a = static_cast<int32_t>(Be32(p + matrix_off));
  const int32_t b = static_cast<int32_t>(Be32(p + matrix_off + 4));
  const double angle =
      std::atan2(b / 65536.0, a / 65536.0) * 180.0 / 3.14159265358979323846;
  int deg = static_cast<int>(std::lround(angle));
  deg = ((deg % 360) + 360) % 360;
  int snapped = 0;
  if (deg >= 45 && deg < 135) {
    snapped = 90;
  } else if (deg >= 135 && deg < 225) {
    snapped = 180;
  } else if (deg >= 225 && deg < 315) {
    snapped = 270;
  }
  extras->rotation = snapped;
}

bool IsBoxContainer(uint32_t type) {
  return type == FourCC('m', 'o', 'o', 'v') || type == FourCC('t', 'r', 'a', 'k') ||
         type == FourCC('m', 'd', 'i', 'a') || type == FourCC('m', 'i', 'n', 'f') ||
         type == FourCC('s', 't', 'b', 'l') || type == FourCC('u', 'd', 't', 'a') ||
         type == FourCC('m', 'e', 't', 'a') || type == FourCC('i', 'l', 's', 't');
}

void WalkMp4Boxes(const uint8_t* data, size_t start, size_t end, uint32_t parent,
                  AvExtras* extras) {
  size_t offset = start;
  while (offset + 8 <= end) {
    uint64_t size = Be32(data + offset);
    const uint32_t type = Be32(data + offset + 4);
    size_t header = 8;
    if (size == 1 && offset + 16 <= end) {
      size = (uint64_t(Be32(data + offset + 8)) << 32) | Be32(data + offset + 12);
      header = 16;
    } else if (size == 0) {
      size = end - offset;
    }
    if (size < header || offset + size > end) {
      break;
    }
    const size_t payload = offset + header;
    const size_t box_end = offset + static_cast<size_t>(size);
    size_t child_start = payload;
    if (type == FourCC('m', 'e', 't', 'a') && payload + 4 <= box_end) {
      child_start = payload + 4;
    }
    if (parent == FourCC('i', 'l', 's', 't')) {
      WalkMp4Boxes(data, payload, box_end, type, extras);
    } else if (IsBoxContainer(type)) {
      WalkMp4Boxes(data, child_start, box_end, type, extras);
    } else if (type == FourCC('t', 'k', 'h', 'd')) {
      ParseTkhd(data + payload, box_end - payload, extras);
    } else if (type == FourCC('d', 'a', 't', 'a') && box_end > payload + 8) {
      const uint8_t format = data[payload + 3];
      if (format == 1 || format == 0) {
        std::string text(reinterpret_cast<const char*>(data + payload + 8),
                         box_end - payload - 8);
        AssignUserData(parent, std::move(text), extras);
      }
    } else if ((type & 0xFF000000) == 0xA9000000 &&
               parent == FourCC('u', 'd', 't', 'a')) {
      size_t i = (box_end - payload >= 4) ? 4 : 0;
      std::string text(reinterpret_cast<const char*>(data + payload + i),
                       box_end > payload + i ? box_end - payload - i : 0);
      AssignUserData(type, std::move(text), extras);
    }
    offset = box_end;
  }
}

AvExtras ParseMp4Extras(const uint8_t* data, size_t size) {
  AvExtras extras;
  size_t offset = 0;
  while (offset + 8 <= size) {
    uint64_t box = Be32(data + offset);
    const uint32_t type = Be32(data + offset + 4);
    size_t header = 8;
    if (box == 1 && offset + 16 <= size) {
      box = (uint64_t(Be32(data + offset + 8)) << 32) | Be32(data + offset + 12);
      header = 16;
    } else if (box == 0) {
      box = size - offset;
    }
    if (box < header || offset + box > size) {
      break;
    }
    if (type == FourCC('m', 'o', 'o', 'v')) {
      WalkMp4Boxes(data, offset + header, offset + static_cast<size_t>(box),
                   type, &extras);
      break;
    }
    offset += static_cast<size_t>(box);
  }
  return extras;
}

AvExtras ParseMp4ExtrasFromPath(const std::wstring& path) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    return {};
  }
  in.seekg(0, std::ios::end);
  const int64_t file_end = in.tellg();
  in.seekg(0);
  int64_t offset = 0;
  while (offset + 8 <= file_end) {
    in.seekg(offset);
    uint8_t hdr[16] = {};
    in.read(reinterpret_cast<char*>(hdr), 8);
    if (in.gcount() < 8) {
      break;
    }
    uint64_t size = Be32(hdr);
    const uint32_t type = Be32(hdr + 4);
    int header = 8;
    if (size == 1) {
      in.read(reinterpret_cast<char*>(hdr), 8);
      size = (uint64_t(Be32(hdr)) << 32) | Be32(hdr + 4);
      header = 16;
    } else if (size == 0) {
      size = static_cast<uint64_t>(file_end - offset);
    }
    if (type == FourCC('m', 'o', 'o', 'v')) {
      if (size > 64ull * 1024ull * 1024ull) {
        break;
      }
      std::vector<uint8_t> moov(static_cast<size_t>(size));
      in.seekg(offset);
      in.read(reinterpret_cast<char*>(moov.data()),
              static_cast<std::streamsize>(size));
      moov.resize(static_cast<size_t>(std::max<std::streamsize>(0, in.gcount())));
      AvExtras extras;
      if (moov.size() > static_cast<size_t>(header)) {
        WalkMp4Boxes(moov.data(), static_cast<size_t>(header), moov.size(), type,
                     &extras);
      }
      return extras;
    }
    offset += static_cast<int64_t>(size);
  }
  return {};
}

template <typename T>
void ApplyAvExtras(T& message, const AvExtras& extras) {
  if (extras.make) {
    message.set_make(*extras.make);
  }
  if (extras.model) {
    message.set_model(*extras.model);
  }
  if (extras.lat && extras.lng) {
    if (extras.alt) {
      const double alt = *extras.alt;
      message.set_gps(GpsLocationMessage(*extras.lat, *extras.lng, &alt));
    } else {
      message.set_gps(GpsLocationMessage(*extras.lat, *extras.lng));
    }
  }
}

MediaMetadataMessage ReadAvFromReader(IMFSourceReader* reader,
                                      const AvExtras& extras) {
  std::optional<int64_t> duration_ms;
  PROPVARIANT dur;
  PropVariantInit(&dur);
  if (SUCCEEDED(reader->GetPresentationAttribute(MF_SOURCE_READER_MEDIASOURCE,
                                                 MF_PD_DURATION, &dur)) &&
      dur.vt == VT_UI8) {
    duration_ms = static_cast<int64_t>(dur.uhVal.QuadPart / 10000);
  }
  PropVariantClear(&dur);

  ComPtr<IMFMediaType> video_type;
  const bool has_video = SUCCEEDED(reader->GetCurrentMediaType(
      MF_SOURCE_READER_FIRST_VIDEO_STREAM, &video_type));
  ComPtr<IMFMediaType> audio_type;
  reader->GetCurrentMediaType(MF_SOURCE_READER_FIRST_AUDIO_STREAM, &audio_type);

  if (has_video) {
    UINT32 w = 0, h = 0;
    MFGetAttributeSize(video_type.Get(), MF_MT_FRAME_SIZE, &w, &h);
    UINT32 bitrate = 0;
    video_type->GetUINT32(MF_MT_AVG_BITRATE, &bitrate);
    UINT32 mf_rot = 0;
    int64_t rotation = extras.rotation.value_or(0);
    if (SUCCEEDED(video_type->GetUINT32(MF_MT_VIDEO_ROTATION, &mf_rot))) {
      rotation = mf_rot;
    }
    if (rotation % 180 == 90) {
      std::swap(w, h);
    }
    VideoMetadataMessage video(flutter::EncodableList{});
    if (duration_ms) video.set_duration_ms(*duration_ms);
    if (w > 0 && h > 0) {
      video.set_size(PixelSizeMessage(w, h));
    }
    if (bitrate > 0) video.set_bitrate(bitrate);
    video.set_rotation_degrees(rotation);
    ApplyAvExtras(video, extras);
    MediaMetadataMessage message(MediaKindMessage::kVideo);
    message.set_video(video);
    return message;
  }

  if (!audio_type) {
    Fail("trackNotFound", "No video or audio track.");
  }
  AudioMetadataMessage audio(flutter::EncodableList{});
  if (duration_ms) audio.set_duration_ms(*duration_ms);
  UINT32 rate = 0, channels = 0, bitrate = 0;
  audio_type->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &rate);
  audio_type->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &channels);
  audio_type->GetUINT32(MF_MT_AUDIO_AVG_BYTES_PER_SECOND, &bitrate);
  if (rate > 0) audio.set_sample_rate(rate);
  if (channels > 0) audio.set_channel_count(channels);
  if (bitrate > 0) audio.set_bitrate(bitrate * 8);
  ApplyAvExtras(audio, extras);
  MediaMetadataMessage message(MediaKindMessage::kAudio);
  message.set_audio(audio);
  return message;
}

MediaMetadataMessage ReadAvFromFile(const std::wstring& path) {
  ComPtr<IMFSourceReader> reader;
  const HRESULT hr = MFCreateSourceReaderFromURL(path.c_str(), nullptr, &reader);
  if (FAILED(hr)) {
    Fail("unsupportedFormat", "Media Foundation could not open the container.");
  }
  return ReadAvFromReader(reader.Get(), ParseMp4ExtrasFromPath(path));
}

MediaMetadataMessage ReadAvFromMemory(const std::vector<uint8_t>& data) {
  ComPtr<IStream> stream;
  stream.Attach(SHCreateMemStream(data.data(), static_cast<UINT>(data.size())));
  if (!stream) {
    Fail("io", "Unable to wrap bytes as IStream.");
  }
  ComPtr<IMFByteStream> byte_stream;
  if (FAILED(MFCreateMFByteStreamOnStream(stream.Get(), &byte_stream))) {
    Fail("unsupportedFormat", "Unable to create IMFByteStream from IStream.");
  }
  ComPtr<IMFSourceReader> reader;
  if (FAILED(MFCreateSourceReaderFromByteStream(byte_stream.Get(), nullptr,
                                                &reader))) {
    Fail("unsupportedFormat", "Media Foundation could not open the container.");
  }
  return ReadAvFromReader(reader.Get(), ParseMp4Extras(data.data(), data.size()));
}

MediaMetadataMessage ReadAvInternal(const MediaSourceMessage& source,
                                    const std::wstring& assets_dir) {
  switch (source.kind()) {
    case SourceKindMessage::kFile:
      if (!source.uri()) {
        Fail("notFound", "Missing path.");
      }
      return ReadAvFromFile(Utf8ToWide(*source.uri()));
    case SourceKindMessage::kAsset: {
      if (!source.uri()) {
        Fail("notFound", "Missing asset key.");
      }
      return ReadAvFromFile(AssetFullPath(assets_dir, *source.uri()));
    }
    case SourceKindMessage::kBytes:
      if (!source.bytes()) {
        Fail("notFound", "Missing byte payload.");
      }
      return ReadAvFromMemory(*source.bytes());
  }
  Fail("unsupported", "Unknown source kind.");
}

template <typename T>
void Reply(const std::function<void(ErrorOr<T> reply)>& result,
           std::function<T()> body) {
  try {
    result(body());
  } catch (const MediaException& error) {
    result(FlutterError(error.code(), error.what()));
  } catch (const std::exception& error) {
    result(FlutterError("malformed", error.what()));
  }
}

}  // namespace

void XueHuaMediaInfoWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  wchar_t exe_path[MAX_PATH];
  GetModuleFileNameW(nullptr, exe_path, MAX_PATH);
  std::wstring dir(exe_path);
  const size_t slash = dir.find_last_of(L"\\/");
  dir = dir.substr(0, slash) + L"\\data\\flutter_assets";
  auto plugin = std::make_unique<XueHuaMediaInfoWindowsPlugin>(std::move(dir));
  MediaInfoHostApi::SetUp(registrar->messenger(), plugin.get());
  registrar->AddPlugin(std::move(plugin));
}

XueHuaMediaInfoWindowsPlugin::XueHuaMediaInfoWindowsPlugin(std::wstring assets_dir)
    : assets_dir_(std::move(assets_dir)) {
  MFStartup(MF_VERSION);
}

XueHuaMediaInfoWindowsPlugin::~XueHuaMediaInfoWindowsPlugin() { MFShutdown(); }

void XueHuaMediaInfoWindowsPlugin::Read(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<MediaMetadataMessage> reply)> result) {
  Reply<MediaMetadataMessage>(result, [&] {
    const auto prefix = LoadPrefix(source, assets_dir_, kHeaderBytes);
    const auto kind = Sniff(prefix, source.uri());
    if (kind == MediaKindMessage::kImage) {
      const auto data = LoadBytes(source, assets_dir_);
      MediaMetadataMessage message(MediaKindMessage::kImage);
      message.set_image(ReadImage(data));
      return message;
    }
    return ReadAvInternal(source, assets_dir_);
  });
}

void XueHuaMediaInfoWindowsPlugin::ReadImage(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<ImageMetadataMessage> reply)> result) {
  Reply<ImageMetadataMessage>(result, [&] {
    const auto prefix = LoadPrefix(source, assets_dir_, kHeaderBytes);
    if (Sniff(prefix, source.uri()) != MediaKindMessage::kImage) {
      Fail("wrongKind", "Source is not an image.");
    }
    return ReadImage(LoadBytes(source, assets_dir_));
  });
}

void XueHuaMediaInfoWindowsPlugin::ReadAv(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<MediaMetadataMessage> reply)> result) {
  Reply<MediaMetadataMessage>(result, [&] {
    const auto prefix = LoadPrefix(source, assets_dir_, kHeaderBytes);
    if (Sniff(prefix, source.uri()) == MediaKindMessage::kImage) {
      Fail("wrongKind", "Source is an image, not an AV container.");
    }
    return ReadAvInternal(source, assets_dir_);
  });
}

void XueHuaMediaInfoWindowsPlugin::Probe(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<MediaKindMessage> reply)> result) {
  Reply<MediaKindMessage>(result, [&] {
    return Sniff(LoadPrefix(source, assets_dir_, kHeaderBytes), source.uri());
  });
}

void XueHuaMediaInfoWindowsPlugin::ReadMotionPhoto(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<VideoMetadataMessage> reply)> result) {
  Reply<VideoMetadataMessage>(result, [&] {
    const auto data = LoadBytes(source, assets_dir_);
    const auto offset = MotionPhotoOffset(data);
    if (!offset) {
      Fail("trackNotFound", "No embedded Motion Photo video.");
    }
    std::vector<uint8_t> embedded(data.begin() + *offset, data.end());
    MediaMetadataMessage parsed = ReadAvFromMemory(embedded);
    if (!parsed.video()) {
      Fail("trackNotFound", "Embedded trailer is not a video.");
    }
    return *parsed.video();
  });
}

}  // namespace xue_hua_media_info_windows
