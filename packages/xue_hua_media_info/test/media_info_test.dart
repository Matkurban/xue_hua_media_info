import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';
import 'package:xue_hua_media_info_platform_interface/xue_hua_media_info_platform_interface.dart';

import 'fake_platform.dart';

void main() {
  late FakeMediaInfoPlatform platform;

  setUp(() {
    platform = FakeMediaInfoPlatform();
    XueHuaMediaInfoPlatform.instance = platform;
  });

  test('read returns ImageMetadata and is exhaustive', () async {
    platform.nextRead = const ImageMetadata(
      make: 'Google',
      size: PixelSize(width: 100, height: 80),
      gps: GpsLocation(latitude: 1.5, longitude: 2.5),
      hasMotionPhoto: true,
    );

    final meta = await MediaInfo.read(MediaSource.file('/tmp/a.jpg'));
    switch (meta) {
      case ImageMetadata(
        :final make,
        :final size,
        :final gps,
        :final hasMotionPhoto,
      ):
        expect(make, 'Google');
        expect(size, const PixelSize(width: 100, height: 80));
        expect(gps?.latitude, 1.5);
        expect(hasMotionPhoto, isTrue);
      case VideoMetadata():
        fail('expected image');
      case AudioMetadata():
        fail('expected image');
    }
    expect(platform.calls, ['read:MediaSource.file(/tmp/a.jpg)']);
  });

  test('readImage throws wrongKind when the stub is not an image', () async {
    platform.nextRead = const VideoMetadata();

    await expectLater(
      MediaInfo.readImage(MediaSource.bytes([0, 1, 2])),
      throwsA(
        isA<MediaInfoError>().having(
          (e) => e.code,
          'code',
          MediaInfoError.codeWrongKind,
        ),
      ),
    );
  });

  test('readAv returns VideoMetadata', () async {
    platform.nextAv = const VideoMetadata(
      duration: Duration(seconds: 2),
      size: PixelSize(width: 1280, height: 720),
    );

    final av = await MediaInfo.readAv(
      const MediaSource.asset('assets/clip.mp4'),
    );
    expect(av, isA<VideoMetadata>());
    expect(av.duration, const Duration(seconds: 2));
  });

  test('probe and readMotionPhoto are forwarded', () async {
    platform.nextKind = MediaKind.audio;
    expect(await MediaInfo.probe(MediaSource.file('/a.m4a')), MediaKind.audio);

    final clip = await MediaInfo.readMotionPhoto(MediaSource.file('/a.jpg'));
    expect(clip.duration, const Duration(milliseconds: 500));
    expect(platform.calls, [
      'probe:MediaSource.file(/a.m4a)',
      'readMotionPhoto:MediaSource.file(/a.jpg)',
    ]);
  });

  test('readAv throws wrongKind', () async {
    platform.nextError = const MediaInfoError(
      code: MediaInfoError.codeWrongKind,
      message: 'image',
    );

    await expectLater(
      MediaInfo.readAv(MediaSource.file('/a.jpg')),
      throwsA(
        isA<MediaInfoError>().having(
          (e) => e.code,
          'code',
          MediaInfoError.codeWrongKind,
        ),
      ),
    );
  });

  test('every documented error code surfaces', () async {
    const codes = [
      MediaInfoError.codeUnsupported,
      MediaInfoError.codeWrongKind,
      MediaInfoError.codeIo,
      MediaInfoError.codeUnsupportedFormat,
      MediaInfoError.codeExifNotFound,
      MediaInfoError.codeTrackNotFound,
      MediaInfoError.codeMalformed,
      MediaInfoError.codeNotFound,
    ];
    for (final code in codes) {
      platform.nextError = MediaInfoError(code: code, message: code);
      await expectLater(
        MediaInfo.probe(MediaSource.file('/x')),
        throwsA(isA<MediaInfoError>().having((e) => e.code, 'code', code)),
      );
    }
  });

  test('PixelSize and GpsLocation equality', () {
    expect(
      const PixelSize(width: 10, height: 20),
      const PixelSize(width: 10, height: 20),
    );
    expect(
      const GpsLocation(latitude: 1, longitude: 2, altitudeMeters: 3),
      const GpsLocation(latitude: 1, longitude: 2, altitudeMeters: 3),
    );
  });
}
