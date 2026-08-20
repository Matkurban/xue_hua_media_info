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

  test('file sniff of ftyp is video', () {
    final ftyp = Uint8List(12);
    ftyp.setAll(4, 'ftyp'.codeUnits);
    ftyp.setAll(8, 'isom'.codeUnits);
    expect(sniffMediaKind(ftyp), MediaKind.video);
  });
}
