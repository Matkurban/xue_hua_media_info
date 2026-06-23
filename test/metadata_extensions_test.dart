import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  group('VideoTrackExtension', () {
    test('reads durationMs and dimensions from entries', () {
      const track = VideoTrack(
        entries: [
          MetadataEntry(
            tagName: 'DurationMs',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1063',
          ),
          MetadataEntry(
            tagName: 'Width',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1920',
          ),
          MetadataEntry(
            tagName: 'Height',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1080',
          ),
        ],
        parseErrors: [],
      );

      expect(track.durationMs, 1063);
      expect(track.duration, const Duration(milliseconds: 1063));
      expect(track.width, 1920);
      expect(track.height, 1080);
    });
  });

  group('ImageExifExtension', () {
    test('reads common EXIF fields from entries', () {
      const exif = ImageExif(
        entries: [
          MetadataEntry(
            tagName: 'Make',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.text,
            displayValue: 'vivo',
          ),
          MetadataEntry(
            tagName: 'ExifImageWidth',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '4032',
          ),
        ],
        hasEmbeddedVideo: false,
        parseErrors: [],
      );

      expect(exif.make, 'vivo');
      expect(exif.width, 4032);
    });
  });

  group('MetadataEntryListExtension', () {
    test('entryNamed returns matching tag', () {
      const entries = [
        MetadataEntry(
          tagName: 'Model',
          tagCode: 0,
          ifdIndex: 0,
          valueKind: MetadataValueKind.text,
          displayValue: 'iPhone',
        ),
      ];

      expect(entries.stringValue('Model'), 'iPhone');
      expect(entries.stringValue('Make'), isNull);
    });
  });
}
