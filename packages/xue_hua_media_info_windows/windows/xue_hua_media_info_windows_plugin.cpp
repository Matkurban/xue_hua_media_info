#include "xue_hua_media_info_windows_plugin.h"

#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <shlwapi.h>
#include <wincodec.h>
#include <windows.h>
#include <wrl/client.h>

#include <cctype>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iterator>
#include <map>
#include <optional>
#include <sstream>
#include <stdexcept>
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

std::optional<int64_t> MotionPhotoOffset(const std::vector<uint8_t>& data) {
  std::string latin(data.begin(), data.end());
  const std::string key = "GCamera:MicroVideoOffset";
  const auto pos = latin.find(key);
  if (pos != std::string::npos) {
    const auto quote = latin.find('"', pos);
    if (quote != std::string::npos) {
      const auto end = latin.find('"', quote + 1);
      if (end != std::string::npos) {
        try {
          const int from_end = std::stoi(latin.substr(quote + 1, end - quote - 1));
          const int64_t start = static_cast<int64_t>(data.size()) - from_end;
          if (start > 0 && start < static_cast<int64_t>(data.size())) {
            return start;
          }
        } catch (...) {
        }
      }
    }
  }
  const int32_t ftyp = FindAscii(data, "ftyp", 2);
  if (ftyp >= 4) {
    return ftyp - 4;
  }
  return std::nullopt;
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

std::vector<uint8_t> ReadFileBytes(const std::wstring& path) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    Fail("notFound", "File not found.");
  }
  return std::vector<uint8_t>(std::istreambuf_iterator<char>(in),
                              std::istreambuf_iterator<char>());
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
      std::wstring path = assets_dir + L"\\" + Utf8ToWide(*source.uri());
      for (auto& c : path) {
        if (c == L'/') {
          c = L'\\';
        }
      }
      return ReadFileBytes(path);
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
    ComPtr<IWICStream> stream;
    if (SUCCEEDED(factory->CreateStream(&stream)) &&
        SUCCEEDED(stream->InitializeFromMemory(
            const_cast<BYTE*>(data.data()), static_cast<DWORD>(data.size())))) {
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

MediaMetadataMessage ReadAvFromFile(const std::wstring& path) {
  ComPtr<IMFSourceReader> reader;
  HRESULT hr = MFCreateSourceReaderFromURL(path.c_str(), nullptr, &reader);
  if (FAILED(hr)) {
    Fail("unsupportedFormat", "Media Foundation could not open the container.");
  }

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
    VideoMetadataMessage video(flutter::EncodableList{});
    if (duration_ms) video.set_duration_ms(*duration_ms);
    if (w > 0 && h > 0) {
      video.set_size(PixelSizeMessage(w, h));
    }
    if (bitrate > 0) video.set_bitrate(bitrate);
    MediaMetadataMessage message(MediaKindMessage::kVideo);
    message.set_video(video);
    return message;
  }

  AudioMetadataMessage audio(flutter::EncodableList{});
  if (duration_ms) audio.set_duration_ms(*duration_ms);
  if (audio_type) {
    UINT32 rate = 0, channels = 0, bitrate = 0;
    audio_type->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &rate);
    audio_type->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &channels);
    audio_type->GetUINT32(MF_MT_AUDIO_AVG_BYTES_PER_SECOND, &bitrate);
    if (rate > 0) audio.set_sample_rate(rate);
    if (channels > 0) audio.set_channel_count(channels);
    if (bitrate > 0) audio.set_bitrate(bitrate * 8);
  }
  MediaMetadataMessage message(MediaKindMessage::kAudio);
  message.set_audio(audio);
  return message;
}

std::wstring WriteTemp(const std::vector<uint8_t>& data) {
  wchar_t dir[MAX_PATH];
  GetTempPathW(MAX_PATH, dir);
  wchar_t path[MAX_PATH];
  GetTempFileNameW(dir, L"xhmi", 0, path);
  FILE* file = nullptr;
  _wfopen_s(&file, path, L"wb");
  if (!file) {
    Fail("io", "Unable to create a temporary file.");
  }
  fwrite(data.data(), 1, data.size(), file);
  fclose(file);
  return path;
}

MediaMetadataMessage ReadAv(const MediaSourceMessage& source,
                            const std::vector<uint8_t>& data,
                            const std::wstring& assets_dir) {
  std::wstring path;
  bool temp = false;
  switch (source.kind()) {
    case SourceKindMessage::kFile:
      path = Utf8ToWide(*source.uri());
      break;
    case SourceKindMessage::kAsset: {
      path = assets_dir + L"\\" + Utf8ToWide(*source.uri());
      for (auto& c : path) {
        if (c == L'/') c = L'\\';
      }
      break;
    }
    case SourceKindMessage::kBytes:
      path = WriteTemp(data);
      temp = true;
      break;
  }
  MediaMetadataMessage result = ReadAvFromFile(path);
  if (temp) {
    DeleteFileW(path.c_str());
  }
  return result;
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
    const auto data = LoadBytes(source, assets_dir_);
    const auto kind = Sniff(data, source.uri());
    if (kind == MediaKindMessage::kImage) {
      MediaMetadataMessage message(MediaKindMessage::kImage);
      message.set_image(ReadImage(data));
      return message;
    }
    return ReadAv(source, data, assets_dir_);
  });
}

void XueHuaMediaInfoWindowsPlugin::ReadImage(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<ImageMetadataMessage> reply)> result) {
  Reply<ImageMetadataMessage>(result, [&] {
    const auto data = LoadBytes(source, assets_dir_);
    if (Sniff(data, source.uri()) != MediaKindMessage::kImage) {
      Fail("wrongKind", "Source is not an image.");
    }
    return ReadImage(data);
  });
}

void XueHuaMediaInfoWindowsPlugin::ReadAv(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<MediaMetadataMessage> reply)> result) {
  Reply<MediaMetadataMessage>(result, [&] {
    const auto data = LoadBytes(source, assets_dir_);
    if (Sniff(data, source.uri()) == MediaKindMessage::kImage) {
      Fail("wrongKind", "Source is an image, not an AV container.");
    }
    return ReadAv(source, data, assets_dir_);
  });
}

void XueHuaMediaInfoWindowsPlugin::Probe(
    const MediaSourceMessage& source,
    std::function<void(ErrorOr<MediaKindMessage> reply)> result) {
  Reply<MediaKindMessage>(result, [&] {
    auto data = LoadBytes(source, assets_dir_);
    if (data.size() > 64) {
      data.resize(64);
    }
    return Sniff(data, source.uri());
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
    const auto temp = WriteTemp(embedded);
    MediaMetadataMessage parsed = ReadAvFromFile(temp);
    DeleteFileW(temp.c_str());
    if (!parsed.video()) {
      Fail("trackNotFound", "Embedded trailer is not a video.");
    }
    return *parsed.video();
  });
}

}  // namespace xue_hua_media_info_windows
