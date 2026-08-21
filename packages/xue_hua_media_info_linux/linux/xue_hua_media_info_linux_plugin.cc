#include "include/xue_hua_media_info_linux/xue_hua_media_info_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gst/gst.h>
#include <gst/pbutils/pbutils.h>

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iterator>
#include <map>
#include <optional>
#include <stdexcept>
#include <string>
#include <unistd.h>
#include <vector>

#include <glib/gstdio.h>

#include "messages.g.h"

#define XUE_HUA_MEDIA_INFO_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), xue_hua_media_info_linux_plugin_get_type(), \
                              XueHuaMediaInfoLinuxPlugin))

struct _XueHuaMediaInfoLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(XueHuaMediaInfoLinuxPlugin, xue_hua_media_info_linux_plugin,
              g_object_get_type())

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

bool EndsWith(const std::string& value, const char* suffix) {
  const size_t n = strlen(suffix);
  return value.size() >= n && value.compare(value.size() - n, n, suffix) == 0;
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
          const uint8_t* p =
              EntryPayload(tiff, tiff_size, ori->second, little, &n);
          if (p && n >= 2) {
            out->orientation = U16(p, little);
          }
        }
        auto read_sub = [&](uint16_t tag, std::map<uint16_t, TiffEntry>* dest) {
          const auto it = ifd0.find(tag);
          if (it == ifd0.end()) {
            return;
          }
          ReadIfd(tiff, tiff_size, U32(it->second.value, little), little, dest);
        };
        std::map<uint16_t, TiffEntry> exif;
        read_sub(0x8769, exif);
        out->date_original = EntryAscii(tiff, tiff_size, exif, 0x9003, little);
        out->date_digitized = EntryAscii(tiff, tiff_size, exif, 0x9004, little);
        std::map<uint16_t, TiffEntry> gps;
        read_sub(0x8825, gps);
        auto rational3 = [&](uint16_t tag) -> std::optional<double> {
          const auto it = gps.find(tag);
          if (it == gps.end()) {
            return std::nullopt;
          }
          size_t n = 0;
          const uint8_t* p =
              EntryPayload(tiff, tiff_size, it->second, little, &n);
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
          if (lat_ref && *lat_ref == "S") *lat = -*lat;
          if (lng_ref && *lng_ref == "W") *lng = -*lng;
          out->lat = lat;
          out->lng = lng;
          auto rational1 = [&](uint16_t tag) -> std::optional<double> {
            const auto it = gps.find(tag);
            if (it == gps.end()) {
              return std::nullopt;
            }
            size_t n = 0;
            const uint8_t* p =
                EntryPayload(tiff, tiff_size, it->second, little, &n);
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

XhmiMessagesMediaKindMessage Sniff(const std::vector<uint8_t>& prefix,
                                   const char* uri) {
  std::string lower = uri ? uri : "";
  for (char& c : lower) {
    c = static_cast<char>(tolower(static_cast<unsigned char>(c)));
  }
  if (EndsWith(lower, ".raf") || EndsWith(lower, ".cr3") || EndsWith(lower, ".iiq")) {
    Fail("unsupportedFormat", "RAW formats are not supported.");
  }
  if (prefix.size() >= 15 && memcmp(prefix.data(), "FUJIFILMCCD-RAW", 15) == 0) {
    Fail("unsupportedFormat", "Fujifilm RAF is not supported.");
  }
  if (prefix.size() >= 3 && prefix[0] == 0xFF && prefix[1] == 0xD8) {
    return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_IMAGE;
  }
  if (prefix.size() >= 8 && prefix[0] == 0x89 && prefix[1] == 0x50 &&
      prefix[2] == 0x4E && prefix[3] == 0x47) {
    return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_IMAGE;
  }
  if (prefix.size() >= 4 &&
      ((prefix[0] == 0x49 && prefix[1] == 0x49) ||
       (prefix[0] == 0x4D && prefix[1] == 0x4D))) {
    if (FindAscii(prefix, "IIQ", 0) >= 0) {
      Fail("unsupportedFormat", "Phase One IIQ is not supported.");
    }
    Fail("unsupportedFormat", "TIFF is not supported on Linux.");
  }
  if (prefix.size() >= 12 && memcmp(prefix.data() + 4, "ftyp", 4) == 0) {
    const std::string brand(reinterpret_cast<const char*>(prefix.data() + 8), 4);
    if (brand.rfind("crx", 0) == 0) {
      Fail("unsupportedFormat", "Canon CR3 is not supported.");
    }
    if (brand == "heic" || brand == "heif" || brand == "mif1" || brand == "msf1" ||
        brand == "avif" || brand == "avis") {
      Fail("unsupportedFormat", "HEIC/HEIF is not supported on Linux.");
    }
    return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_VIDEO;
  }
  if (prefix.size() >= 4 && prefix[0] == 0x1A && prefix[1] == 0x45 &&
      prefix[2] == 0xDF && prefix[3] == 0xA3) {
    return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_VIDEO;
  }
  if (EndsWith(lower, ".m4a") || EndsWith(lower, ".aac") ||
      EndsWith(lower, ".mp3") || EndsWith(lower, ".wav")) {
    return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_AUDIO;
  }
  Fail("unsupportedFormat", "Unrecognized media header.");
  return XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_VIDEO;
}

constexpr size_t kHeaderBytes = 256;

std::vector<uint8_t> ReadPath(const std::string& path) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    Fail("notFound", "File not found: " + path);
  }
  return std::vector<uint8_t>(std::istreambuf_iterator<char>(in),
                              std::istreambuf_iterator<char>());
}

std::vector<uint8_t> ReadPathPrefix(const std::string& path, size_t count) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    Fail("notFound", "File not found: " + path);
  }
  std::vector<uint8_t> buffer(count);
  in.read(reinterpret_cast<char*>(buffer.data()),
          static_cast<std::streamsize>(count));
  buffer.resize(static_cast<size_t>(std::max<std::streamsize>(0, in.gcount())));
  return buffer;
}

std::string AssetPath(const char* key) {
  g_autofree gchar* exe_path = g_file_read_link("/proc/self/exe", nullptr);
  g_autofree gchar* dir = g_path_get_dirname(exe_path != nullptr ? exe_path : ".");
  g_autofree gchar* asset =
      g_build_filename(dir, "data", "flutter_assets", key, nullptr);
  return asset;
}

std::vector<uint8_t> LoadPrefix(XhmiMessagesMediaSourceMessage* source,
                                size_t count) {
  switch (xhmi_messages_media_source_message_get_kind(source)) {
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_FILE: {
      const gchar* uri = xhmi_messages_media_source_message_get_uri(source);
      if (uri == nullptr) {
        Fail("notFound", "Missing path.");
      }
      return ReadPathPrefix(uri, count);
    }
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES: {
      size_t length = 0;
      const uint8_t* bytes =
          xhmi_messages_media_source_message_get_bytes(source, &length);
      if (bytes == nullptr) {
        Fail("notFound", "Missing byte payload.");
      }
      const size_t n = std::min(count, length);
      return std::vector<uint8_t>(bytes, bytes + n);
    }
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_ASSET: {
      const gchar* uri = xhmi_messages_media_source_message_get_uri(source);
      if (uri == nullptr) {
        Fail("notFound", "Missing asset key.");
      }
      return ReadPathPrefix(AssetPath(uri), count);
    }
  }
  Fail("unsupported", "Unknown source kind.");
  return {};
}

std::vector<uint8_t> LoadBytes(XhmiMessagesMediaSourceMessage* source) {
  switch (xhmi_messages_media_source_message_get_kind(source)) {
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_FILE: {
      const gchar* uri = xhmi_messages_media_source_message_get_uri(source);
      if (uri == nullptr) {
        Fail("notFound", "Missing path.");
      }
      return ReadPath(uri);
    }
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES: {
      size_t length = 0;
      const uint8_t* bytes =
          xhmi_messages_media_source_message_get_bytes(source, &length);
      if (bytes == nullptr) {
        Fail("notFound", "Missing byte payload.");
      }
      return std::vector<uint8_t>(bytes, bytes + length);
    }
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_ASSET: {
      const gchar* uri = xhmi_messages_media_source_message_get_uri(source);
      if (uri == nullptr) {
        Fail("notFound", "Missing asset key.");
      }
      return ReadPath(AssetPath(uri));
    }
  }
  Fail("unsupported", "Unknown source kind.");
  return {};
}

std::string SourceFilePath(XhmiMessagesMediaSourceMessage* source,
                           const std::vector<uint8_t>& data, bool* temp) {
  *temp = false;
  switch (xhmi_messages_media_source_message_get_kind(source)) {
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_FILE:
      return xhmi_messages_media_source_message_get_uri(source);
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_ASSET:
      return AssetPath(xhmi_messages_media_source_message_get_uri(source));
    case XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES: {
      g_autofree gchar* path = nullptr;
      const gint fd = g_file_open_tmp("xhmiXXXXXX", &path, nullptr);
      if (fd < 0) {
        Fail("io", "Unable to create a temporary file.");
      }
      if (write(fd, data.data(), data.size()) < 0) {
        close(fd);
        Fail("io", "Unable to write a temporary file.");
      }
      close(fd);
      *temp = true;
      return path;
    }
  }
  Fail("unsupported", "Unknown source kind.");
  return {};
}

XhmiMessagesImageMetadataMessage* BuildImage(
    const std::vector<uint8_t>& data) {
  ImageFields fields;
  if (data.size() >= 3 && data[0] == 0xFF && data[1] == 0xD8) {
    ParseJpegExif(data, &fields);
  } else if (data.size() >= 8 && data[0] == 0x89) {
    ParsePng(data, &fields);
  } else {
    Fail("unsupportedFormat", "Not a JPEG or PNG image.");
  }
  fields.has_motion_photo = MotionPhotoOffset(data).has_value();

  g_autoptr(XhmiMessagesPixelSizeMessage) size = nullptr;
  if (fields.width && fields.height) {
    size = xhmi_messages_pixel_size_message_new(*fields.width, *fields.height);
  }
  int64_t orientation = 0;
  int64_t* orientation_ptr = nullptr;
  if (fields.orientation) {
    orientation = *fields.orientation;
    orientation_ptr = &orientation;
  }
  g_autoptr(XhmiMessagesGpsLocationMessage) gps = nullptr;
  if (fields.lat && fields.lng) {
    double alt = 0;
    double* alt_ptr = nullptr;
    if (fields.alt) {
      alt = *fields.alt;
      alt_ptr = &alt;
    }
    gps = xhmi_messages_gps_location_message_new(*fields.lat, *fields.lng, alt_ptr);
  }
  g_autoptr(FlValue) png_text = fl_value_new_list();
  for (const auto& chunk : fields.png_text) {
    XhmiMessagesPngTextChunkMessage* item =
        xhmi_messages_png_text_chunk_message_new(chunk.first.c_str(),
                                                 chunk.second.c_str());
    fl_value_append_take(
        png_text, fl_value_new_custom_object(
                      xhmi_messages_png_text_chunk_message_type_id, G_OBJECT(item)));
    g_object_unref(item);
  }
  g_autoptr(FlValue) extra = fl_value_new_list();
  return xhmi_messages_image_metadata_message_new(
      fields.make ? fields.make->c_str() : nullptr,
      fields.model ? fields.model->c_str() : nullptr,
      fields.software ? fields.software->c_str() : nullptr, size,
      orientation_ptr, fields.date_original ? fields.date_original->c_str() : nullptr,
      fields.date_digitized ? fields.date_digitized->c_str() : nullptr,
      fields.date_modified ? fields.date_modified->c_str() : nullptr, gps,
      fields.has_motion_photo ? TRUE : FALSE, png_text, extra);
}

XhmiMessagesMediaMetadataMessage* DiscoverAv(const std::string& path) {
  g_autoptr(GError) error = nullptr;
  g_autofree gchar* uri = gst_filename_to_uri(path.c_str(), &error);
  if (uri == nullptr) {
    Fail("io", error && error->message ? error->message : "Invalid path.");
  }
  g_autoptr(GstDiscoverer) discoverer =
      gst_discoverer_new(5 * GST_SECOND, &error);
  if (discoverer == nullptr) {
    Fail("unsupportedFormat",
         error && error->message ? error->message : "GstDiscoverer failed.");
  }
  g_autoptr(GstDiscovererInfo) info =
      gst_discoverer_discover_uri(discoverer, uri, &error);
  if (info == nullptr) {
    Fail("unsupportedFormat",
         error && error->message ? error->message : "Unable to read container.");
  }
  const GstDiscovererResult result = gst_discoverer_info_get_result(info);
  if (result != GST_DISCOVERER_OK && result != GST_DISCOVERER_MISSING_PLUGINS) {
    Fail("unsupportedFormat", "GStreamer could not discover this container.");
  }

  int64_t duration_ms = 0;
  int64_t* duration_ptr = nullptr;
  const GstClockTime duration = gst_discoverer_info_get_duration(info);
  if (GST_CLOCK_TIME_IS_VALID(duration)) {
    duration_ms = static_cast<int64_t>(duration / GST_MSECOND);
    duration_ptr = &duration_ms;
  }

  const GstTagList* tags = gst_discoverer_info_get_tags(info);
  gchar* make = nullptr;
  gchar* model = nullptr;
  if (tags != nullptr) {
    gst_tag_list_get_string(tags, GST_TAG_DEVICE_MANUFACTURER, &make);
    gst_tag_list_get_string(tags, GST_TAG_DEVICE_MODEL, &model);
  }
  g_autoptr(XhmiMessagesGpsLocationMessage) gps = nullptr;
  if (tags != nullptr) {
    gdouble lat = 0, lng = 0, alt = 0;
    const gboolean has_lat =
        gst_tag_list_get_double(tags, GST_TAG_GEO_LOCATION_LATITUDE, &lat);
    const gboolean has_lng =
        gst_tag_list_get_double(tags, GST_TAG_GEO_LOCATION_LONGITUDE, &lng);
    if (has_lat && has_lng) {
      double* alt_ptr = nullptr;
      if (gst_tag_list_get_double(tags, GST_TAG_GEO_LOCATION_ELEVATION, &alt)) {
        alt_ptr = &alt;
      }
      gps = xhmi_messages_gps_location_message_new(lat, lng, alt_ptr);
    }
  }

  GList* videos = gst_discoverer_info_get_video_streams(info);
  GList* audios = gst_discoverer_info_get_audio_streams(info);
  if (videos == nullptr && audios == nullptr) {
    g_free(make);
    g_free(model);
    Fail("trackNotFound", "No video or audio track.");
  }
  g_autoptr(FlValue) extra = fl_value_new_list();
  XhmiMessagesMediaMetadataMessage* message = nullptr;
  if (videos != nullptr) {
    auto* video_info = GST_DISCOVERER_VIDEO_INFO(videos->data);
    int64_t width = gst_discoverer_video_info_get_width(video_info);
    int64_t height = gst_discoverer_video_info_get_height(video_info);
    int64_t rotation = 0;
    int64_t* rotation_ptr = nullptr;
    if (tags != nullptr) {
      gchar* orientation = nullptr;
      if (gst_tag_list_get_string(tags, GST_TAG_IMAGE_ORIENTATION, &orientation) &&
          orientation != nullptr) {
        if (g_str_has_prefix(orientation, "rotate-")) {
          rotation = atoi(orientation + 7);
          rotation = ((rotation % 360) + 360) % 360;
          rotation_ptr = &rotation;
          if (rotation == 90 || rotation == 270) {
            const int64_t tmp = width;
            width = height;
            height = tmp;
          }
        }
        g_free(orientation);
      }
    }
    g_autoptr(XhmiMessagesPixelSizeMessage) size = nullptr;
    if (width > 0 && height > 0) {
      size = xhmi_messages_pixel_size_message_new(width, height);
    }
    guint bitrate = gst_discoverer_video_info_get_bitrate(video_info);
    int64_t bitrate64 = bitrate;
    int64_t* bitrate_ptr = bitrate > 0 ? &bitrate64 : nullptr;
    g_autoptr(XhmiMessagesVideoMetadataMessage) video =
        xhmi_messages_video_metadata_message_new(
            duration_ptr, size, bitrate_ptr, rotation_ptr, make, model, gps, extra);
    message = xhmi_messages_media_metadata_message_new(
        XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_VIDEO, nullptr,
        video, nullptr);
  } else {
    int64_t sample_rate = 0;
    int64_t channels = 0;
    int64_t bitrate64 = 0;
    int64_t* sample_ptr = nullptr;
    int64_t* channel_ptr = nullptr;
    int64_t* bitrate_ptr = nullptr;
    if (audios != nullptr) {
      auto* audio_info = GST_DISCOVERER_AUDIO_INFO(audios->data);
      sample_rate = gst_discoverer_audio_info_get_sample_rate(audio_info);
      channels = gst_discoverer_audio_info_get_channels(audio_info);
      bitrate64 = gst_discoverer_audio_info_get_bitrate(audio_info);
      if (sample_rate > 0) sample_ptr = &sample_rate;
      if (channels > 0) channel_ptr = &channels;
      if (bitrate64 > 0) bitrate_ptr = &bitrate64;
    }
    g_autoptr(XhmiMessagesAudioMetadataMessage) audio =
        xhmi_messages_audio_metadata_message_new(
            duration_ptr, bitrate_ptr, sample_ptr, channel_ptr, make, model, gps,
            extra);
    message = xhmi_messages_media_metadata_message_new(
        XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_AUDIO, nullptr,
        nullptr, audio);
  }
  if (videos) gst_discoverer_stream_info_list_free(videos);
  if (audios) gst_discoverer_stream_info_list_free(audios);
  g_free(make);
  g_free(model);
  return message;
}

template <typename Fn>
void Guard(XhmiMessagesMediaInfoHostApiResponseHandle* handle, Fn body,
           void (*on_error)(XhmiMessagesMediaInfoHostApiResponseHandle*,
                            const gchar*, const gchar*, FlValue*)) {
  try {
    body();
  } catch (const MediaException& error) {
    on_error(handle, error.code().c_str(), error.what(), nullptr);
  } catch (const std::exception& error) {
    on_error(handle, "malformed", error.what(), nullptr);
  }
}

void HandleRead(XhmiMessagesMediaSourceMessage* source,
                XhmiMessagesMediaInfoHostApiResponseHandle* handle,
                gpointer user_data) {
  (void)user_data;
  Guard(
      handle,
      [&] {
        const auto prefix = LoadPrefix(source, kHeaderBytes);
        const auto kind =
            Sniff(prefix, xhmi_messages_media_source_message_get_uri(source));
        if (kind ==
            XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_IMAGE) {
          const auto data = LoadBytes(source);
          g_autoptr(XhmiMessagesImageMetadataMessage) image = BuildImage(data);
          g_autoptr(XhmiMessagesMediaMetadataMessage) message =
              xhmi_messages_media_metadata_message_new(kind, image, nullptr,
                                                       nullptr);
          xhmi_messages_media_info_host_api_respond_read(handle, message);
          return;
        }
        bool temp = false;
        std::vector<uint8_t> payload;
        if (xhmi_messages_media_source_message_get_kind(source) ==
            XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES) {
          payload = LoadBytes(source);
        }
        const std::string path = SourceFilePath(source, payload, &temp);
        g_autoptr(XhmiMessagesMediaMetadataMessage) message = DiscoverAv(path);
        if (temp) {
          g_unlink(path.c_str());
        }
        xhmi_messages_media_info_host_api_respond_read(handle, message);
      },
      xhmi_messages_media_info_host_api_respond_error_read);
}

void HandleReadImage(XhmiMessagesMediaSourceMessage* source,
                     XhmiMessagesMediaInfoHostApiResponseHandle* handle,
                     gpointer user_data) {
  (void)user_data;
  Guard(
      handle,
      [&] {
        const auto prefix = LoadPrefix(source, kHeaderBytes);
        const auto kind =
            Sniff(prefix, xhmi_messages_media_source_message_get_uri(source));
        if (kind !=
            XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_IMAGE) {
          Fail("wrongKind", "Source is not an image.");
        }
        const auto data = LoadBytes(source);
        g_autoptr(XhmiMessagesImageMetadataMessage) image = BuildImage(data);
        xhmi_messages_media_info_host_api_respond_read_image(handle, image);
      },
      xhmi_messages_media_info_host_api_respond_error_read_image);
}

void HandleReadAv(XhmiMessagesMediaSourceMessage* source,
                  XhmiMessagesMediaInfoHostApiResponseHandle* handle,
                  gpointer user_data) {
  (void)user_data;
  Guard(
      handle,
      [&] {
        const auto prefix = LoadPrefix(source, kHeaderBytes);
        const auto kind =
            Sniff(prefix, xhmi_messages_media_source_message_get_uri(source));
        if (kind ==
            XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_MEDIA_KIND_MESSAGE_IMAGE) {
          Fail("wrongKind", "Source is an image, not an AV container.");
        }
        bool temp = false;
        std::vector<uint8_t> payload;
        if (xhmi_messages_media_source_message_get_kind(source) ==
            XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES) {
          payload = LoadBytes(source);
        }
        const std::string path = SourceFilePath(source, payload, &temp);
        g_autoptr(XhmiMessagesMediaMetadataMessage) message = DiscoverAv(path);
        if (temp) {
          g_unlink(path.c_str());
        }
        xhmi_messages_media_info_host_api_respond_read_av(handle, message);
      },
      xhmi_messages_media_info_host_api_respond_error_read_av);
}

void HandleProbe(XhmiMessagesMediaSourceMessage* source,
                 XhmiMessagesMediaInfoHostApiResponseHandle* handle,
                 gpointer user_data) {
  (void)user_data;
  Guard(
      handle,
      [&] {
        auto data = LoadPrefix(source, kHeaderBytes);
        const auto kind =
            Sniff(data, xhmi_messages_media_source_message_get_uri(source));
        xhmi_messages_media_info_host_api_respond_probe(handle, kind);
      },
      xhmi_messages_media_info_host_api_respond_error_probe);
}

void HandleReadMotionPhoto(XhmiMessagesMediaSourceMessage* source,
                           XhmiMessagesMediaInfoHostApiResponseHandle* handle,
                           gpointer user_data) {
  (void)user_data;
  Guard(
      handle,
      [&] {
        const auto data = LoadBytes(source);
        const auto offset = MotionPhotoOffset(data);
        if (!offset) {
          Fail("trackNotFound", "No embedded Motion Photo video.");
        }
        std::vector<uint8_t> embedded(data.begin() + *offset, data.end());
        bool temp = true;
        XhmiMessagesMediaSourceMessage* bytes_source =
            xhmi_messages_media_source_message_new(
                XUE_HUA_MEDIA_INFO_PLATFORM_INTERFACE_SOURCE_KIND_MESSAGE_BYTES,
                nullptr, embedded.data(), embedded.size());
        const std::string path = SourceFilePath(bytes_source, embedded, &temp);
        g_object_unref(bytes_source);
        g_autoptr(XhmiMessagesMediaMetadataMessage) message = DiscoverAv(path);
        if (temp) {
          g_unlink(path.c_str());
        }
        XhmiMessagesVideoMetadataMessage* video =
            xhmi_messages_media_metadata_message_get_video(message);
        if (video == nullptr) {
          Fail("trackNotFound", "Embedded trailer is not a video.");
        }
        xhmi_messages_media_info_host_api_respond_read_motion_photo(handle, video);
      },
      xhmi_messages_media_info_host_api_respond_error_read_motion_photo);
}

const XhmiMessagesMediaInfoHostApiVTable kVtable = {
    .read = HandleRead,
    .read_image = HandleReadImage,
    .read_av = HandleReadAv,
    .probe = HandleProbe,
    .read_motion_photo = HandleReadMotionPhoto,
};

}  // namespace

static void xue_hua_media_info_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(xue_hua_media_info_linux_plugin_parent_class)->dispose(object);
}

static void xue_hua_media_info_linux_plugin_class_init(
    XueHuaMediaInfoLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = xue_hua_media_info_linux_plugin_dispose;
}

static void xue_hua_media_info_linux_plugin_init(
    XueHuaMediaInfoLinuxPlugin* self) {}

void xue_hua_media_info_linux_plugin_register_with_registrar(
    FlPluginRegistrar* registrar) {
  gst_init(nullptr, nullptr);
  XueHuaMediaInfoLinuxPlugin* plugin = XUE_HUA_MEDIA_INFO_LINUX_PLUGIN(
      g_object_new(xue_hua_media_info_linux_plugin_get_type(), nullptr));
  xhmi_messages_media_info_host_api_set_method_handlers(
      fl_plugin_registrar_get_messenger(registrar), nullptr, &kVtable,
      g_object_ref(plugin), g_object_unref);
  g_object_unref(plugin);
}
