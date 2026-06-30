import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  group('VideoTrackExtension', () {
    test('reads durationMs and dimensions from entries with rawValue', () {
      const track = VideoTrack(
        entries: [
          MetadataEntry(
            tagName: 'DurationMs',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1063',
            rawValue: MetadataValue.integer(1063),
          ),
          MetadataEntry(
            tagName: 'Width',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1920',
            rawValue: MetadataValue.integer(1920),
          ),
          MetadataEntry(
            tagName: 'Height',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '1080',
            rawValue: MetadataValue.integer(1080),
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
    test('reads common EXIF fields from entries with rawValue', () {
      const exif = ImageExif(
        entries: [
          MetadataEntry(
            tagName: 'Make',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.text,
            displayValue: 'vivo',
            rawValue: MetadataValue.text('vivo'),
          ),
          MetadataEntry(
            tagName: 'ExifImageWidth',
            tagCode: 0,
            ifdIndex: 0,
            valueKind: MetadataValueKind.integer,
            displayValue: '4032',
            rawValue: MetadataValue.integer(4032),
          ),
        ],
        hasEmbeddedVideo: false,
        parseErrors: [],
      );

      expect(exif.make, 'vivo');
      expect(exif.width, 4032);
    });
  });

  group('MetadataEntryExtension', () {
    test('asString falls back to displayValue for integer rawValue', () {
      const entry = MetadataEntry(
        tagName: 'Make',
        tagCode: 0,
        ifdIndex: 0,
        valueKind: MetadataValueKind.integer,
        displayValue: 'vivo',
        rawValue: MetadataValue.integer(1),
      );

      expect(entry.asString, 'vivo');
    });

    test('asInt handles rational rawValue', () {
      const entry = MetadataEntry(
        tagName: 'ExposureTime',
        tagCode: 0,
        ifdIndex: 0,
        valueKind: MetadataValueKind.rational,
        displayValue: '3/4',
        rawValue: MetadataValue.rational(
          Rational(numerator: 3, denominator: 4),
        ),
      );

      expect(entry.asInt, 1);
      expect(entry.asDouble, 0.75);
    });

    test('asInt parses displayValue when rawValue is unhandled', () {
      const entry = MetadataEntry(
        tagName: 'Width',
        tagCode: 0,
        ifdIndex: 0,
        valueKind: MetadataValueKind.bytes,
        displayValue: '1920',
        rawValue: MetadataValue.bytes('deadbeef'),
      );

      expect(entry.asInt, 1920);
    });

    test('bytes rawValue does not surface as asString', () {
      const entry = MetadataEntry(
        tagName: 'Undefined',
        tagCode: 0,
        ifdIndex: 0,
        valueKind: MetadataValueKind.bytes,
        displayValue: 'readable',
        rawValue: MetadataValue.bytes('deadbeef'),
      );

      expect(entry.asString, 'readable');
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
          rawValue: MetadataValue.text('iPhone'),
        ),
      ];

      expect(entries.stringValue('Model'), 'iPhone');
      expect(entries.stringValue('Make'), isNull);
    });
  });
}
