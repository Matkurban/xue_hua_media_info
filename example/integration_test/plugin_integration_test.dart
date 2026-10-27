import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';
import 'package:xue_hua_media_info_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const jpegAsset = MediaSource.asset('assets/testdata/exif.jpg');
  const mislabeledPngAsset = MediaSource.asset('assets/testdata/exif.png');
  const realPngAsset = MediaSource.asset('assets/testdata/sample_text.png');
  const movAsset = MediaSource.asset('assets/testdata/meta.mov');
  const mp4Asset = MediaSource.asset('assets/testdata/clip.mp4');
  const wavAsset = MediaSource.asset('assets/testdata/tone.wav');
  const motionAsset =
      MediaSource.asset('assets/testdata/motion_photo_pixel_synth.jpg');

  group('probe', () {
    testWidgets('JPEG asset is image', (tester) async {
      expect(await MediaInfo.probe(jpegAsset), MediaKind.image);
    });

    testWidgets('real PNG asset is image', (tester) async {
      expect(await MediaInfo.probe(realPngAsset), MediaKind.image);
    });

    testWidgets('MOV asset is video', (tester) async {
      expect(await MediaInfo.probe(movAsset), MediaKind.video);
    });

    testWidgets('MP4 asset is video', (tester) async {
      expect(await MediaInfo.probe(mp4Asset), MediaKind.video);
    });

    testWidgets('WAV asset is audio', (tester) async {
      expect(await MediaInfo.probe(wavAsset), MediaKind.audio);
    });
  });

  group('readImage', () {
    testWidgets('JPEG EXIF has make/model/size/gps/dates', (tester) async {
      final image = await MediaInfo.readImage(jpegAsset);
      expect(image.make, isNotNull);
      expect(image.model, isNotNull);
      expect(image.size, isNotNull);
      expect(image.size!.width, greaterThan(0));
      expect(image.size!.height, greaterThan(0));
      expect(image.dateTimeOriginal, isNotNull);
      expect(image.gps, isNotNull);
      expect(image.gps!.latitude, isNot(0));
      expect(image.gps!.longitude, isNot(0));
      expect(image.hasMotionPhoto, isFalse);
    });

    testWidgets('real PNG exposes size and tEXt', (tester) async {
      final image = await MediaInfo.readImage(realPngAsset);
      expect(image.size, const PixelSize(width: 8, height: 8));
      expect(image.pngText, isNotEmpty);
      expect(
        image.pngText.any((c) => c.key == 'Author' && c.value == 'XueHua'),
        isTrue,
      );
    });

    testWidgets('mislabeled JPEG-as-PNG still parses as image via magic', (
      tester,
    ) async {
      // Asset filename ends in .png but bytes are JPEG; parser must use magic.
      final image = await MediaInfo.readImage(mislabeledPngAsset);
      expect(image.size, isNotNull);
      expect(image.pngText, isEmpty);
    });

    testWidgets('wrongKind when reading a video as image', (tester) async {
      await expectLater(
        MediaInfo.readImage(mp4Asset),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            MediaInfoError.codeWrongKind,
          ),
        ),
      );
    });
  });

  group('readAv', () {
    testWidgets('MOV returns VideoMetadata with duration/size', (tester) async {
      final av = await MediaInfo.readAv(movAsset);
      expect(av, isA<VideoMetadata>());
      final video = av as VideoMetadata;
      expect(video.duration, isNotNull);
      expect(video.duration!.inMilliseconds, greaterThan(0));
      expect(video.size, isNotNull);
    });

    testWidgets('generated MP4 returns VideoMetadata', (tester) async {
      final av = await MediaInfo.readAv(mp4Asset);
      expect(av, isA<VideoMetadata>());
      final video = av as VideoMetadata;
      expect(video.duration, isNotNull);
      expect(video.duration!.inMilliseconds, greaterThan(500));
      expect(video.size?.width, 320);
      expect(video.size?.height, 240);
    });

    testWidgets('WAV returns AudioMetadata', (tester) async {
      final av = await MediaInfo.readAv(wavAsset);
      expect(av, isA<AudioMetadata>());
      final audio = av as AudioMetadata;
      expect(audio.duration, isNotNull);
      expect(audio.duration!.inMilliseconds, greaterThan(500));
      expect(audio.sampleRate, isNotNull);
      expect(audio.channelCount, isNotNull);
    });

    testWidgets('wrongKind when reading an image as AV', (tester) async {
      await expectLater(
        MediaInfo.readAv(jpegAsset),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            MediaInfoError.codeWrongKind,
          ),
        ),
      );
    });
  });

  group('read / auto-detect', () {
    testWidgets('read routes JPEG to ImageMetadata', (tester) async {
      final meta = await MediaInfo.read(jpegAsset);
      expect(meta, isA<ImageMetadata>());
    });

    testWidgets('read routes MP4 to VideoMetadata', (tester) async {
      final meta = await MediaInfo.read(mp4Asset);
      expect(meta, isA<VideoMetadata>());
    });

    testWidgets('read routes WAV to AudioMetadata', (tester) async {
      final meta = await MediaInfo.read(wavAsset);
      expect(meta, isA<AudioMetadata>());
    });
  });

  group('file and bytes sources', () {
    testWidgets('FileSource JPEG matches asset probe', (tester) async {
      final bytes = await rootBundle.load('assets/testdata/exif.jpg');
      final tmp = File(
        '${Directory.systemTemp.path}/xhmi_exif_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      await tmp.writeAsBytes(bytes.buffer.asUint8List());
      addTearDown(tmp.deleteSync);

      final kind = await MediaInfo.probe(MediaSource.file(tmp.path));
      expect(kind, MediaKind.image);
      final image = await MediaInfo.readImage(MediaSource.file(tmp.path));
      expect(image.make, isNotNull);
    });

    testWidgets('BytesSource PNG reads tEXt', (tester) async {
      final data = await rootBundle.load('assets/testdata/sample_text.png');
      final image = await MediaInfo.readImage(
        MediaSource.bytes(data.buffer.asUint8List()),
      );
      expect(image.size, const PixelSize(width: 8, height: 8));
      expect(image.pngText.any((c) => c.key == 'Author'), isTrue);
    });

    testWidgets('BytesSource WAV via temp discover', (tester) async {
      final data = await rootBundle.load('assets/testdata/tone.wav');
      final meta = await MediaInfo.read(
        MediaSource.bytes(data.buffer.asUint8List()),
      );
      expect(meta, isA<AudioMetadata>());
    });

    testWidgets('missing file yields notFound/io', (tester) async {
      await expectLater(
        MediaInfo.probe(const MediaSource.file('/tmp/xhmi_does_not_exist_xyz')),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            anyOf(MediaInfoError.codeNotFound, MediaInfoError.codeIo),
          ),
        ),
      );
    });

    testWidgets('garbage bytes yield unsupportedFormat', (tester) async {
      await expectLater(
        MediaInfo.read(MediaSource.bytes(Uint8List.fromList([1, 2, 3, 4]))),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            anyOf(
              MediaInfoError.codeUnsupportedFormat,
              MediaInfoError.codeMalformed,
            ),
          ),
        ),
      );
    });
  });

  group('motion photo', () {
    testWidgets('synthetic Pixel motion photo flagged and extractable', (
      tester,
    ) async {
      final image = await MediaInfo.readImage(motionAsset);
      expect(image.hasMotionPhoto, isTrue);
      final clip = await MediaInfo.readMotionPhoto(motionAsset);
      expect(clip, isA<VideoMetadata>());
      expect(clip.duration, isNotNull);
    });

    testWidgets('plain JPEG has no motion photo trailer', (tester) async {
      final image = await MediaInfo.readImage(jpegAsset);
      expect(image.hasMotionPhoto, isFalse);
      await expectLater(
        MediaInfo.readMotionPhoto(jpegAsset),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            MediaInfoError.codeTrackNotFound,
          ),
        ),
      );
    });
  });


  group('source matrix extras', () {
    testWidgets('FileSource MP4 matches asset VideoMetadata', (tester) async {
      final bytes = await rootBundle.load('assets/testdata/clip.mp4');
      final tmp = File(
        '${Directory.systemTemp.path}/xhmi_clip_${DateTime.now().microsecondsSinceEpoch}.mp4',
      );
      await tmp.writeAsBytes(bytes.buffer.asUint8List());
      addTearDown(tmp.deleteSync);

      final av = await MediaInfo.readAv(MediaSource.file(tmp.path));
      expect(av, isA<VideoMetadata>());
      final video = av as VideoMetadata;
      expect(video.duration?.inMilliseconds, greaterThan(500));
      expect(video.size?.width, 320);
      expect(video.size?.height, 240);
    });

    testWidgets('FileSource WAV matches asset AudioMetadata', (tester) async {
      final bytes = await rootBundle.load('assets/testdata/tone.wav');
      final tmp = File(
        '${Directory.systemTemp.path}/xhmi_tone_${DateTime.now().microsecondsSinceEpoch}.wav',
      );
      await tmp.writeAsBytes(bytes.buffer.asUint8List());
      addTearDown(tmp.deleteSync);

      final av = await MediaInfo.readAv(MediaSource.file(tmp.path));
      expect(av, isA<AudioMetadata>());
      final audio = av as AudioMetadata;
      expect(audio.duration?.inMilliseconds, greaterThan(500));
      expect(audio.sampleRate, isNotNull);
    });

    testWidgets('BytesSource JPEG preserves EXIF make/size/gps', (tester) async {
      final data = await rootBundle.load('assets/testdata/exif.jpg');
      final image = await MediaInfo.readImage(
        MediaSource.bytes(data.buffer.asUint8List()),
      );
      expect(image.make, isNotNull);
      expect(image.size, isNotNull);
      expect(image.gps, isNotNull);
      expect(image.hasMotionPhoto, isFalse);
    });

    testWidgets('BytesSource MP4 returns VideoMetadata', (tester) async {
      final data = await rootBundle.load('assets/testdata/clip.mp4');
      final meta = await MediaInfo.read(
        MediaSource.bytes(data.buffer.asUint8List()),
      );
      expect(meta, isA<VideoMetadata>());
      final video = meta as VideoMetadata;
      expect(video.duration?.inMilliseconds, greaterThan(500));
    });

    testWidgets('probe motion photo asset is image', (tester) async {
      expect(await MediaInfo.probe(motionAsset), MediaKind.image);
    });

    testWidgets('FileSource motion photo extractable', (tester) async {
      final bytes =
          await rootBundle.load('assets/testdata/motion_photo_pixel_synth.jpg');
      final tmp = File(
        '${Directory.systemTemp.path}/xhmi_mp_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      await tmp.writeAsBytes(bytes.buffer.asUint8List());
      addTearDown(tmp.deleteSync);

      final source = MediaSource.file(tmp.path);
      final image = await MediaInfo.readImage(source);
      expect(image.hasMotionPhoto, isTrue);
      final clip = await MediaInfo.readMotionPhoto(source);
      expect(clip.duration, isNotNull);
    });

    testWidgets('BytesSource motion photo extractable', (tester) async {
      final data =
          await rootBundle.load('assets/testdata/motion_photo_pixel_synth.jpg');
      final source = MediaSource.bytes(data.buffer.asUint8List());
      final image = await MediaInfo.readImage(source);
      expect(image.hasMotionPhoto, isTrue);
      final clip = await MediaInfo.readMotionPhoto(source);
      expect(clip, isA<VideoMetadata>());
      expect(clip.duration, isNotNull);
    });

    testWidgets('JPEG orientation field is present when EXIF has it', (
      tester,
    ) async {
      final image = await MediaInfo.readImage(jpegAsset);
      // Sample EXIF JPEG carries orientation; assert type when non-null.
      if (image.orientation != null) {
        expect(image.orientation, inInclusiveRange(1, 8));
      }
      expect(image.dateTimeDigitized ?? image.dateTimeOriginal, isNotNull);
    });

    testWidgets('read routes MOV to VideoMetadata', (tester) async {
      final meta = await MediaInfo.read(movAsset);
      expect(meta, isA<VideoMetadata>());
    });

    testWidgets('readMotionPhoto wrongKind-path: video source fails', (
      tester,
    ) async {
      await expectLater(
        MediaInfo.readMotionPhoto(mp4Asset),
        throwsA(
          isA<MediaInfoError>().having(
            (e) => e.code,
            'code',
            anyOf(
              MediaInfoError.codeTrackNotFound,
              MediaInfoError.codeWrongKind,
              MediaInfoError.codeUnsupportedFormat,
              MediaInfoError.codeMalformed,
            ),
          ),
        ),
      );
    });
  });

  group('example UI', () {
    testWidgets('preview page loads sample metadata without error codes', (
      tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      expect(find.textContaining('xue_hua_media_info'), findsOneWidget);
      String output = '';
      // Async load of multi-MB samples; poll instead of pumpAndSettle.
      for (var i = 0; i < 120; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        final text = find.byType(SelectableText);
        if (text.evaluate().isEmpty) {
          continue;
        }
        output = tester.widget<SelectableText>(text).data ?? '';
        if (output.isNotEmpty && !output.contains('Loading sample metadata')) {
          break;
        }
      }
      expect(output, isNot(contains('Loading sample metadata')));
      expect(output.toLowerCase(), isNot(contains('exception')));
      expect(output, contains('JPEG'));
      expect(output, contains('PNG'));
      expect(output, contains('MOV'));
      expect(output.startsWith('io:'), isFalse);
      expect(output.startsWith('notFound:'), isFalse);
      expect(output.startsWith('unsupportedFormat:'), isFalse);
      // Real PNG sample should surface tEXt Author.
      expect(output, contains('Author'));
    });
  });
}
