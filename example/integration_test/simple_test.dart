import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await XueHuaMediaInfo.initialize();
  });

  Future<List<int>> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  test(
    'readImageExifFromBytes parses sample JPEG and extension getters',
    () async {
      final bytes = await loadAsset('assets/testdata/exif.jpg');
      final exif = XueHuaMediaInfo.readImageExifFromBytes(data: bytes);

      expect(exif.entries, isNotEmpty);
      expect(exif.make, isNotNull);
      expect(exif.entries.any((entry) => entry.tagName == 'Make'), isTrue);
    },
  );

  test(
    'readVideoMetadataFromBytes parses sample MOV and extension getters',
    () async {
      final bytes = await loadAsset('assets/testdata/meta.mov');
      final track = XueHuaMediaInfo.readVideoMetadataFromBytes(data: bytes);

      expect(track.entries, isNotEmpty);
      expect(track.width, isNotNull);
      expect(track.entries.any((entry) => entry.tagName == 'Width'), isTrue);
    },
  );

  test('detectMediaKindFromBytes distinguishes image and video', () async {
    final jpeg = await loadAsset('assets/testdata/exif.jpg');
    final mov = await loadAsset('assets/testdata/meta.mov');

    expect(
      XueHuaMediaInfo.detectMediaKindFromBytes(data: jpeg),
      MediaKind.image,
    );
    expect(
      XueHuaMediaInfo.detectMediaKindFromBytes(data: mov),
      MediaKind.videoOrAudio,
    );
  });

  test('readMediaMetadataFromBytes returns error for empty bytes', () async {
    expect(
      () => XueHuaMediaInfo.readMediaMetadataFromBytes(data: const []),
      throwsA(
        isA<MediaInfoError>().having((error) => error.code, 'code', isNotNull),
      ),
    );
  });

  test('readEmbeddedVideoFromBytes extracts Motion Photo trailer', () async {
    final bytes = await loadAsset(
      'assets/testdata/motion_photo_pixel_synth.jpg',
    );
    final track = XueHuaMediaInfo.readEmbeddedVideoFromBytes(data: bytes);

    expect(track.entries, isNotEmpty);
  });

  test(
    'readEmbeddedVideoFromBytesAsync extracts Motion Photo trailer',
    () async {
      final bytes = await loadAsset(
        'assets/testdata/motion_photo_pixel_synth.jpg',
      );
      final track = await XueHuaMediaInfo.readEmbeddedVideoFromBytesAsync(
        data: bytes,
      );

      expect(track.entries, isNotEmpty);
    },
  );

  test('readImageExifLazyFromBytes preserves per-tag errors shape', () async {
    final bytes = await loadAsset('assets/testdata/exif.jpg');
    final exif = XueHuaMediaInfo.readImageExifLazyFromBytes(data: bytes);

    expect(exif.entries, isNotEmpty);
    expect(exif.parseErrors, isA<List<ParseError>>());
  });

  test('readImageExifFromBytesAsync parses sample JPEG', () async {
    final bytes = await loadAsset('assets/testdata/exif.jpg');
    final exif = await XueHuaMediaInfo.readImageExifFromBytesAsync(data: bytes);

    expect(exif.entries, isNotEmpty);
    expect(exif.entries.any((entry) => entry.tagName == 'Make'), isTrue);
  });

  test('detectMediaKindFromBytesAsync distinguishes image and video', () async {
    final jpeg = await loadAsset('assets/testdata/exif.jpg');
    final mov = await loadAsset('assets/testdata/meta.mov');

    expect(
      await XueHuaMediaInfo.detectMediaKindFromBytesAsync(data: jpeg),
      MediaKind.image,
    );
    expect(
      await XueHuaMediaInfo.detectMediaKindFromBytesAsync(data: mov),
      MediaKind.videoOrAudio,
    );
  });
}
