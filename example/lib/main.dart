import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _output = 'Loading sample metadata...';

  @override
  void initState() {
    super.initState();
    _loadSampleMetadata();
  }

  Future<void> _loadSampleMetadata() async {
    try {
      final jpegBytes = await rootBundle.load('assets/testdata/exif.jpg');
      final movBytes = await rootBundle.load('assets/testdata/meta.mov');

      final imageExif = readImageExifFromBytes(
        data: jpegBytes.buffer.asUint8List(),
      );
      final videoTrack = readVideoMetadataFromBytes(
        data: movBytes.buffer.asUint8List(),
      );

      final make = _findEntry(imageExif.entries, 'Make')?.displayValue ?? '-';
      final model = _findEntry(imageExif.entries, 'Model')?.displayValue ?? '-';
      final width = _findEntry(videoTrack.entries, 'Width')?.displayValue ?? '-';
      final height =
          _findEntry(videoTrack.entries, 'Height')?.displayValue ?? '-';
      final duration =
          _findEntry(videoTrack.entries, 'DurationMs')?.displayValue ?? '-';

      setState(() {
        _output = '''
Image EXIF
  Make: $make
  Model: $model
  Tags: ${imageExif.entries.length}
  Has embedded video: ${imageExif.hasEmbeddedVideo}

Video metadata
  Width: $width
  Height: $height
  Duration (ms): $duration
  Tags: ${videoTrack.entries.length}
''';
      });
    } catch (error) {
      setState(() {
        _output = 'Failed to read metadata: $error';
      });
    }
  }

  MetadataEntryDto? _findEntry(List<MetadataEntryDto> entries, String tagName) {
    for (final entry in entries) {
      if (entry.tagName == tagName) {
        return entry;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('XueHua Media Info')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(_output, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
