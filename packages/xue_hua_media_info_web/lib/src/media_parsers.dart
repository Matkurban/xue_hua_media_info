import 'dart:math';
import 'dart:typed_data';

import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

/// Header-only kind detection from magic bytes.
/// 仅根据魔数判断媒体种类。
MediaKind sniffMediaKind(Uint8List prefix, {String? uri}) {
  final name = uri?.toLowerCase() ?? '';
  if (name.endsWith('.raf') || name.endsWith('.cr3') || name.endsWith('.iiq')) {
    throw const MediaInfoError(
      code: MediaInfoError.codeUnsupportedFormat,
      message: 'RAW formats are not supported.',
    );
  }
  if (prefix.length >= 15 &&
      String.fromCharCodes(prefix.sublist(0, 15)) == 'FUJIFILMCCD-RAW') {
    throw const MediaInfoError(
      code: MediaInfoError.codeUnsupportedFormat,
      message: 'Fujifilm RAF is not supported.',
    );
  }
  if (prefix.length >= 3 && prefix[0] == 0xFF && prefix[1] == 0xD8) {
    return MediaKind.image;
  }
  if (prefix.length >= 8 &&
      prefix[0] == 0x89 &&
      prefix[1] == 0x50 &&
      prefix[2] == 0x4E &&
      prefix[3] == 0x47) {
    return MediaKind.image;
  }
  if (prefix.length >= 4 &&
      ((prefix[0] == 0x49 && prefix[1] == 0x49) ||
          (prefix[0] == 0x4D && prefix[1] == 0x4D))) {
    throw const MediaInfoError(
      code: MediaInfoError.codeUnsupportedFormat,
      message: 'TIFF is not supported on this platform.',
    );
  }
  if (prefix.length >= 12 &&
      String.fromCharCodes(prefix.sublist(4, 8)) == 'ftyp') {
    final brand = String.fromCharCodes(
      prefix.sublist(8, min(12, prefix.length)),
    );
    if (brand.startsWith('crx')) {
      throw const MediaInfoError(
        code: MediaInfoError.codeUnsupportedFormat,
        message: 'Canon CR3 is not supported.',
      );
    }
    const imageBrands = {'heic', 'heif', 'mif1', 'msf1', 'avif', 'avis'};
    if (imageBrands.contains(brand)) {
      throw const MediaInfoError(
        code: MediaInfoError.codeUnsupportedFormat,
        message: 'HEIC/HEIF is not supported on this platform.',
      );
    }
    return MediaKind.video;
  }
  if (prefix.length >= 4 &&
      prefix[0] == 0x1A &&
      prefix[1] == 0x45 &&
      prefix[2] == 0xDF &&
      prefix[3] == 0xA3) {
    throw const MediaInfoError(
      code: MediaInfoError.codeUnsupportedFormat,
      message: 'MKV/WebM is not supported on this platform.',
    );
  }
  if (name.endsWith('.m4a') ||
      name.endsWith('.aac') ||
      name.endsWith('.mp3') ||
      name.endsWith('.wav')) {
    return MediaKind.audio;
  }
  throw const MediaInfoError(
    code: MediaInfoError.codeUnsupportedFormat,
    message: 'Unrecognized media header.',
  );
}

/// Reads JPEG EXIF / PNG tEXt into [ImageMetadata].
/// 将 JPEG EXIF / PNG tEXt 读入 [ImageMetadata]。
ImageMetadata parseImageBytes(Uint8List data) {
  if (data.length >= 8 &&
      data[0] == 0x89 &&
      data[1] == 0x50 &&
      data[2] == 0x4E &&
      data[3] == 0x47) {
    return _parsePng(data);
  }
  if (data.length >= 3 && data[0] == 0xFF && data[1] == 0xD8) {
    return _parseJpeg(data);
  }
  throw const MediaInfoError(
    code: MediaInfoError.codeUnsupportedFormat,
    message: 'Not a JPEG or PNG image.',
  );
}

/// Reads `moov` from MP4/MOV into video or audio metadata.
/// 从 MP4/MOV 的 `moov` 读取视频或音频元数据。
AvMetadata parseAvBytes(Uint8List data) {
  final parsed = _parseMp4(data);
  if (parsed == null) {
    throw const MediaInfoError(
      code: MediaInfoError.codeUnsupportedFormat,
      message: 'Unable to parse MP4/MOV container.',
    );
  }
  return parsed;
}

/// Offset of an embedded Motion Photo MP4, if present.
/// 动态照片内嵌 MP4 的起始偏移（若有）。
int? motionPhotoOffset(Uint8List data) {
  final latin = String.fromCharCodes(data);
  final micro =
      RegExp(r'GCamera:MicroVideoOffset\s*=\s*"(\d+)"').firstMatch(latin) ??
      RegExp(r'MicroVideoOffset>\s*(\d+)').firstMatch(latin);
  if (micro != null) {
    final fromEnd = int.tryParse(micro.group(1)!);
    if (fromEnd == null) {
      return null;
    }
    final start = data.length - fromEnd;
    if (start > 0 && start < data.length) {
      return start;
    }
  }
  final ftyp = latin.lastIndexOf('ftyp');
  if (ftyp >= 4) {
    return ftyp - 4;
  }
  return null;
}

ImageMetadata _parsePng(Uint8List data) {
  PixelSize? size;
  final text = <PngTextChunk>[];
  var offset = 8;
  while (offset + 12 <= data.length) {
    final length = _be32(data, offset);
    if (length < 0 || offset + 12 + length > data.length) {
      break;
    }
    final type = String.fromCharCodes(data.sublist(offset + 4, offset + 8));
    final payload = data.sublist(offset + 8, offset + 8 + length);
    if (type == 'IHDR' && payload.length >= 8) {
      size = PixelSize(
        width: _be32(data, offset + 8),
        height: _be32(data, offset + 12),
      );
    } else if (type == 'tEXt') {
      final split = payload.indexOf(0);
      if (split > 0) {
        text.add(
          PngTextChunk(
            key: String.fromCharCodes(payload.sublist(0, split)),
            value: String.fromCharCodes(payload.sublist(split + 1)),
          ),
        );
      }
    }
    if (type == 'IEND') {
      break;
    }
    offset += 12 + length;
  }
  return ImageMetadata(size: size, pngText: text);
}

ImageMetadata _parseJpeg(Uint8List data) {
  PixelSize? size;
  _TiffIfd? ifd;
  var offset = 2;
  while (offset + 4 <= data.length && data[offset] == 0xFF) {
    final marker = data[offset + 1];
    if (marker == 0xDA || marker == 0xD9) {
      break;
    }
    if (marker >= 0xD0 && marker <= 0xD7) {
      offset += 2;
      continue;
    }
    final length = (data[offset + 2] << 8) | data[offset + 3];
    if (length < 2 || offset + 2 + length > data.length) {
      break;
    }
    final payload = data.sublist(offset + 4, offset + 2 + length);
    if (marker == 0xE1 &&
        payload.length >= 6 &&
        String.fromCharCodes(payload.sublist(0, 4)) == 'Exif') {
      ifd = _TiffIfd.parse(payload.sublist(6));
    }
    if ((marker >= 0xC0 && marker <= 0xC3) ||
        (marker >= 0xC5 && marker <= 0xC7) ||
        (marker >= 0xC9 && marker <= 0xCB) ||
        (marker >= 0xCD && marker <= 0xCF)) {
      if (payload.length >= 5) {
        final height = (payload[1] << 8) | payload[2];
        final width = (payload[3] << 8) | payload[4];
        size = PixelSize(width: width, height: height);
      }
    }
    offset += 2 + length;
  }
  return ImageMetadata(
    make: ifd?.ascii(0x010F),
    model: ifd?.ascii(0x0110),
    software: ifd?.ascii(0x0131),
    size: size ?? ifd?.size,
    orientation: ifd?.short(0x0112),
    dateTimeOriginal: _parseExifDate(ifd?.ascii(0x9003)),
    dateTimeDigitized: _parseExifDate(ifd?.ascii(0x9004)),
    dateTimeModified: _parseExifDate(ifd?.ascii(0x0132)),
    gps: ifd?.gps,
    hasMotionPhoto: motionPhotoOffset(data) != null,
  );
}

DateTime? _parseExifDate(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final match = RegExp(
    r'^(\d{4}):(\d{2}):(\d{2})[ T](\d{2}):(\d{2}):(\d{2})',
  ).firstMatch(raw);
  if (match == null) {
    return DateTime.tryParse(raw);
  }
  return DateTime(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.parse(match.group(6)!),
  );
}

class _TiffIfd {
  _TiffIfd(this.bytes, this.little);

  final Uint8List bytes;
  final bool little;
  final Map<int, _TiffEntry> entries = {};
  GpsLocation? gps;
  PixelSize? size;

  static _TiffIfd? parse(Uint8List bytes) {
    if (bytes.length < 8) {
      return null;
    }
    final little = bytes[0] == 0x49;
    final magic = _u16(bytes, 2, little);
    if (magic != 42) {
      return null;
    }
    final ifd0 = _u32(bytes, 4, little);
    final parsed = _TiffIfd(bytes, little).._readIfd(ifd0);
    parsed.size = parsed._pixelSize();
    final gpsOffset = parsed.entries[0x8825]?.asLong(bytes, little);
    if (gpsOffset != null) {
      final gpsIfd = _TiffIfd(bytes, little).._readIfd(gpsOffset);
      parsed.gps = gpsIfd._gps();
    }
    final exifOffset = parsed.entries[0x8769]?.asLong(bytes, little);
    if (exifOffset != null) {
      final exif = _TiffIfd(bytes, little).._readIfd(exifOffset);
      parsed.entries.addAll(exif.entries);
    }
    return parsed;
  }

  void _readIfd(int offset) {
    if (offset + 2 > bytes.length) {
      return;
    }
    final count = _u16(bytes, offset, little);
    var cursor = offset + 2;
    for (var i = 0; i < count; i++) {
      if (cursor + 12 > bytes.length) {
        break;
      }
      final tag = _u16(bytes, cursor, little);
      final type = _u16(bytes, cursor + 2, little);
      final countValues = _u32(bytes, cursor + 4, little);
      final value = bytes.sublist(cursor + 8, cursor + 12);
      entries[tag] = _TiffEntry(type, countValues, value);
      cursor += 12;
    }
  }

  String? ascii(int tag) {
    final entry = entries[tag];
    if (entry == null || entry.type != 2) {
      return null;
    }
    final raw = entry.payload(bytes, little);
    final end = raw.indexOf(0);
    final slice = end >= 0 ? raw.sublist(0, end) : raw;
    if (slice.isEmpty) {
      return null;
    }
    return String.fromCharCodes(slice);
  }

  int? short(int tag) {
    final entry = entries[tag];
    if (entry == null) {
      return null;
    }
    return entry.asShort(bytes, little);
  }

  PixelSize? _pixelSize() {
    final width =
        entries[0xA002]?.asLong(bytes, little) ??
        entries[0x0100]?.asLong(bytes, little);
    final height =
        entries[0xA003]?.asLong(bytes, little) ??
        entries[0x0101]?.asLong(bytes, little);
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    return PixelSize(width: width, height: height);
  }

  GpsLocation? _gps() {
    final lat = _coord(0x0002, 0x0001);
    final lng = _coord(0x0004, 0x0003);
    if (lat == null || lng == null) {
      return null;
    }
    final altEntry = entries[0x0006];
    double? altitude;
    if (altEntry != null) {
      final rationals = altEntry.rationals(bytes, little);
      if (rationals.isNotEmpty) {
        altitude = rationals.first;
        if (short(0x0005) == 1) {
          altitude = -altitude;
        }
      }
    }
    return GpsLocation(latitude: lat, longitude: lng, altitudeMeters: altitude);
  }

  double? _coord(int tag, int refTag) {
    final entry = entries[tag];
    if (entry == null) {
      return null;
    }
    final parts = entry.rationals(bytes, little);
    if (parts.length < 3) {
      return null;
    }
    var value = parts[0] + parts[1] / 60 + parts[2] / 3600;
    final ref = ascii(refTag);
    if (ref == 'S' || ref == 'W') {
      value = -value;
    }
    return value;
  }
}

class _TiffEntry {
  _TiffEntry(this.type, this.count, this.valueOffset);

  final int type;
  final int count;
  final Uint8List valueOffset;

  Uint8List payload(Uint8List bytes, bool little) {
    final unit = switch (type) {
      1 || 2 => 1,
      3 => 2,
      4 => 4,
      5 || 10 => 8,
      _ => 1,
    };
    final size = unit * count;
    if (size <= 4) {
      return valueOffset.sublist(0, min(size, valueOffset.length));
    }
    final offset = _u32(valueOffset, 0, little);
    if (offset < 0 || offset + size > bytes.length) {
      return Uint8List(0);
    }
    return bytes.sublist(offset, offset + size);
  }

  int? asShort(Uint8List bytes, bool little) {
    final raw = payload(bytes, little);
    if (raw.length < 2) {
      return null;
    }
    return _u16(raw, 0, little);
  }

  int? asLong(Uint8List bytes, bool little) {
    if (type == 3) {
      return asShort(bytes, little);
    }
    final raw = payload(bytes, little);
    if (raw.length < 4) {
      return null;
    }
    return _u32(raw, 0, little);
  }

  List<double> rationals(Uint8List bytes, bool little) {
    final raw = payload(bytes, little);
    final result = <double>[];
    for (var i = 0; i + 8 <= raw.length; i += 8) {
      final num = _u32(raw, i, little);
      final den = _u32(raw, i + 4, little);
      result.add(den == 0 ? 0 : num / den);
    }
    return result;
  }
}

AvMetadata? _parseMp4(Uint8List data) {
  var hasVideo = false;
  var hasAudio = false;
  int? durationMs;
  PixelSize? size;
  int? timescale;

  void walk(int start, int end) {
    var offset = start;
    while (offset + 8 <= end) {
      var boxSize = _be32(data, offset);
      final type = String.fromCharCodes(data.sublist(offset + 4, offset + 8));
      if (boxSize == 1 && offset + 16 <= end) {
        boxSize = _be32(data, offset + 8) << 32 | _be32(data, offset + 12);
      }
      if (boxSize < 8 || offset + boxSize > end) {
        break;
      }
      final header = boxSize == 1 ? 16 : 8;
      final payloadStart = offset + header;
      final payloadEnd = offset + boxSize;
      if (type == 'moov' ||
          type == 'trak' ||
          type == 'mdia' ||
          type == 'minf' ||
          type == 'stbl') {
        walk(payloadStart, payloadEnd);
      } else if (type == 'mvhd' && payloadEnd - payloadStart >= 20) {
        final version = data[payloadStart];
        if (version == 1 && payloadEnd - payloadStart >= 32) {
          timescale = _be32(data, payloadStart + 20);
          final durHi = _be32(data, payloadStart + 24);
          final durLo = _be32(data, payloadStart + 28);
          final duration = (durHi << 32) | durLo;
          if (timescale != null && timescale! > 0) {
            durationMs = (duration * 1000) ~/ timescale!;
          }
        } else {
          timescale = _be32(data, payloadStart + 12);
          final duration = _be32(data, payloadStart + 16);
          if (timescale != null && timescale! > 0) {
            durationMs = (duration * 1000) ~/ timescale!;
          }
        }
      } else if (type == 'tkhd' && payloadEnd - payloadStart >= 84) {
        final version = data[payloadStart];
        final dimOffset = version == 1 ? 88 : 76;
        if (payloadStart + dimOffset + 8 <= payloadEnd) {
          final width = _be32(data, payloadStart + dimOffset) >> 16;
          final height = _be32(data, payloadStart + dimOffset + 4) >> 16;
          if (width > 0 && height > 0) {
            size = PixelSize(width: width, height: height);
          }
        }
      } else if (type == 'hdlr' && payloadEnd - payloadStart >= 12) {
        final component = String.fromCharCodes(
          data.sublist(payloadStart + 8, payloadStart + 12),
        );
        if (component == 'vide') {
          hasVideo = true;
        } else if (component == 'soun') {
          hasAudio = true;
        }
      }
      offset += boxSize;
    }
  }

  walk(0, data.length);
  if (!hasVideo && !hasAudio && durationMs == null) {
    return null;
  }
  if (hasVideo) {
    return VideoMetadata(
      duration: durationMs == null ? null : Duration(milliseconds: durationMs!),
      size: size,
    );
  }
  return AudioMetadata(
    duration: durationMs == null ? null : Duration(milliseconds: durationMs!),
  );
}

int _be32(Uint8List data, int offset) {
  return (data[offset] << 24) |
      (data[offset + 1] << 16) |
      (data[offset + 2] << 8) |
      data[offset + 3];
}

int _u16(Uint8List data, int offset, bool little) {
  if (little) {
    return data[offset] | (data[offset + 1] << 8);
  }
  return (data[offset] << 8) | data[offset + 1];
}

int _u32(Uint8List data, int offset, bool little) {
  if (little) {
    return data[offset] |
        (data[offset + 1] << 8) |
        (data[offset + 2] << 16) |
        (data[offset + 3] << 24);
  }
  return (data[offset] << 24) |
      (data[offset + 1] << 16) |
      (data[offset + 2] << 8) |
      data[offset + 3];
}
