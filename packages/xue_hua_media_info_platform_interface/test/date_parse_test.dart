import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info_platform_interface/src/method_channel_xue_hua_media_info.dart';

void main() {
  test('parseMetadataDate understands EXIF and ISO strings', () {
    expect(
      parseMetadataDate('2020:01:02 03:04:05'),
      DateTime(2020, 1, 2, 3, 4, 5),
    );
    expect(
      parseMetadataDate('2020-01-02T03:04:05'),
      DateTime(2020, 1, 2, 3, 4, 5),
    );
    expect(parseMetadataDate(null), isNull);
    expect(parseMetadataDate(''), isNull);
    expect(parseMetadataDate('not-a-date'), isNull);
  });
}
