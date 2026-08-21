import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';
// ignore: implementation_imports
import 'package:xue_hua_media_info_web/src/media_parsers.dart';

void main() {
  test('sniffKind recognizes JPEG and PNG', () {
    expect(
      sniffMediaKind(Uint8List.fromList(const [0xFF, 0xD8, 0xFF])),
      MediaKind.image,
    );
    expect(
      sniffMediaKind(
        Uint8List.fromList(const [
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
        ]),
      ),
      MediaKind.image,
    );
  });

  test('sniffKind rejects HEIC, TIFF, MKV and RAW', () {
    expect(
      () => sniffMediaKind(Uint8List.fromList(const [0x49, 0x49, 0x2A, 0x00])),
      throwsA(
        isA<MediaInfoError>().having(
          (e) => e.code,
          'code',
          MediaInfoError.codeUnsupportedFormat,
        ),
      ),
    );
    expect(
      () => sniffMediaKind(Uint8List.fromList('FUJIFILMCCD-RAW'.codeUnits)),
      throwsA(isA<MediaInfoError>()),
    );
  });

  test('parseImageBytes reads PNG IHDR and tEXt', () {
    final png = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, // IHDR length 13
      0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x02, // width 2
      0x00, 0x00, 0x00, 0x03, // height 3
      0x08, 0x02, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, // crc
      0x00, 0x00, 0x00, 0x08, // tEXt length 8
      0x74, 0x45, 0x58, 0x74,
      0x41, 0x00, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x49, 0x45, 0x4E, 0x44,
      0x00, 0x00, 0x00, 0x00,
    ]);
    final meta = parseImageBytes(png);
    expect(meta.size, const PixelSize(width: 2, height: 3));
    expect(meta.pngText, isNotEmpty);
    expect(meta.pngText.first.key, 'A');
  });

  test('motionPhotoOffset requires XMP, not a raw ftyp search', () {
    final jpeg = Uint8List.fromList([
      0xFF,
      0xD8,
      0xFF,
      0xE0,
      0x00,
      0x10,
      ...List<int>.filled(20, 0),
      ...('xxxxftypisom').codeUnits,
    ]);
    expect(motionPhotoOffset(jpeg), isNull);
  });

  test('motionPhotoOffset reads MicroVideoOffset from XMP', () {
    const xmp = '<x:xmpmeta>GCamera:MicroVideoOffset="8"</x:xmpmeta>';
    final data = Uint8List.fromList([
      0xFF,
      0xD8,
      ...xmp.codeUnits,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
    ]);
    expect(motionPhotoOffset(data), data.length - 8);
  });

  test('parseAvBytes reports trackNotFound for an empty moov', () {
    final mp4 = Uint8List.fromList([
      0x00,
      0x00,
      0x00,
      0x0C,
      ...'ftyp'.codeUnits,
      ...'isom'.codeUnits,
      0x00,
      0x00,
      0x00,
      0x08,
      ...'moov'.codeUnits,
    ]);
    expect(
      () => parseAvBytes(mp4),
      throwsA(
        isA<MediaInfoError>().having(
          (e) => e.code,
          'code',
          MediaInfoError.codeTrackNotFound,
        ),
      ),
    );
  });

  test('parseAvBytes fills rotation and swapped display size from tkhd', () {
    // ftyp + moov[ trak[ tkhd 90° + mdia[ hdlr vide ] ] ]
    final tkhd = Uint8List(84);
    tkhd[0] = 0; // version
    // matrix at 40: a=0, b=1.0 (90°)
    tkhd[44] = 0x00;
    tkhd[45] = 0x01;
    tkhd[46] = 0x00;
    tkhd[47] = 0x00; // b = 65536
    // width 1920, height 1080 as 16.16 at 76/80
    tkhd[76] = 0x07;
    tkhd[77] = 0x80;
    tkhd[80] = 0x04;
    tkhd[81] = 0x38;

    final hdlr = Uint8List(12);
    hdlr.setAll(8, 'vide'.codeUnits);

    Uint8List box(String type, Uint8List payload) {
      final size = 8 + payload.length;
      final out = Uint8List(size);
      out[0] = (size >> 24) & 0xFF;
      out[1] = (size >> 16) & 0xFF;
      out[2] = (size >> 8) & 0xFF;
      out[3] = size & 0xFF;
      out.setAll(4, type.codeUnits);
      out.setAll(8, payload);
      return out;
    }

    final mdia = box('mdia', box('hdlr', hdlr));
    final trak = box(
      'trak',
      Uint8List.fromList([...box('tkhd', tkhd), ...mdia]),
    );
    final moov = box('moov', trak);
    final ftyp = box('ftyp', Uint8List.fromList('isom'.codeUnits));
    final mp4 = Uint8List.fromList([...ftyp, ...moov]);
    final parsed = parseAvBytes(mp4);
    expect(parsed, isA<VideoMetadata>());
    final video = parsed as VideoMetadata;
    expect(video.rotationDegrees, 90);
    expect(video.size, const PixelSize(width: 1080, height: 1920));
  });

  test('parseAvBytes reads ©mak/©mod/©xyz from udta', () {
    Uint8List box(String type, List<int> payload) {
      final size = 8 + payload.length;
      final out = Uint8List(size);
      out[0] = (size >> 24) & 0xFF;
      out[1] = (size >> 16) & 0xFF;
      out[2] = (size >> 8) & 0xFF;
      out[3] = size & 0xFF;
      if (type.length == 4) {
        out.setAll(4, type.codeUnits);
      }
      out.setAll(8, payload);
      return out;
    }

    Uint8List copyrightBox(String rest, String value) {
      final type = Uint8List.fromList([0xA9, ...rest.codeUnits]);
      final payload = Uint8List.fromList([0, 0, 0, 0, ...value.codeUnits]);
      final size = 8 + payload.length;
      final out = Uint8List(size);
      out[0] = (size >> 24) & 0xFF;
      out[1] = (size >> 16) & 0xFF;
      out[2] = (size >> 8) & 0xFF;
      out[3] = size & 0xFF;
      out.setAll(4, type);
      out.setAll(8, payload);
      return out;
    }

    final hdlr = Uint8List(12);
    hdlr.setAll(8, 'soun'.codeUnits);
    final mdia = box('mdia', box('hdlr', hdlr));
    final tkhd = Uint8List(84);
    final trak = box('trak', [...box('tkhd', tkhd), ...mdia]);
    final udta = box('udta', [
      ...copyrightBox('mak', 'Apple'),
      ...copyrightBox('mod', 'iPhone'),
      ...copyrightBox('xyz', '+37.7749-122.4194+10/'),
    ]);
    final moov = box('moov', [...trak, ...udta]);
    final ftyp = box('ftyp', 'isom'.codeUnits);
    final parsed = parseAvBytes(Uint8List.fromList([...ftyp, ...moov]));
    expect(parsed, isA<AudioMetadata>());
    final audio = parsed as AudioMetadata;
    expect(audio.make, 'Apple');
    expect(audio.model, 'iPhone');
    expect(audio.gps?.latitude, closeTo(37.7749, 0.0001));
    expect(audio.gps?.longitude, closeTo(-122.4194, 0.0001));
    expect(audio.gps?.altitudeMeters, closeTo(10, 0.001));
  });

  test('file sniff of ftyp is video', () {
    final ftyp = Uint8List(12);
    ftyp.setAll(4, 'ftyp'.codeUnits);
    ftyp.setAll(8, 'isom'.codeUnits);
    expect(sniffMediaKind(ftyp), MediaKind.video);
  });
}
