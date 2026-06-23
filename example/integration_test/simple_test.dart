import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await RustLib.init();
  });

  Future<List<int>> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  test('readImageExifFromBytes parses sample JPEG', () async {
    final bytes = await loadAsset('assets/testdata/exif.jpg');
    final exif = readImageExifFromBytes(data: bytes);

    expect(exif.entries, isNotEmpty);
    expect(
      exif.entries.any((entry) => entry.tagName == 'Make'),
      isTrue,
    );
  });

  test('readVideoMetadataFromBytes parses sample MOV', () async {
    final bytes = await loadAsset('assets/testdata/meta.mov');
    final track = readVideoMetadataFromBytes(data: bytes);

    expect(track.entries, isNotEmpty);
    expect(
      track.entries.any((entry) => entry.tagName == 'Width'),
      isTrue,
    );
  });

  test('detectMediaKindFromBytes distinguishes image and video', () async {
    final jpeg = await loadAsset('assets/testdata/exif.jpg');
    final mov = await loadAsset('assets/testdata/meta.mov');

    expect(
      detectMediaKindFromBytes(data: jpeg),
      MediaKindDto.image,
    );
    expect(
      detectMediaKindFromBytes(data: mov),
      MediaKindDto.videoOrAudio,
    );
  });

  test('readMediaMetadataFromBytes returns error for empty bytes', () async {
    expect(
      () => readMediaMetadataFromBytes(data: const []),
      throwsA(isA<MediaInfoError>()),
    );
  });
}
