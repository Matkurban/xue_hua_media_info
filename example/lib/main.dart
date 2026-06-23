import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await XueHuaMediaInfo.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('XueHua Media Info')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: _MetadataPreview(),
        ),
      ),
    );
  }
}

class _MetadataPreview extends StatefulWidget {
  const _MetadataPreview();

  @override
  State<_MetadataPreview> createState() => _MetadataPreviewState();
}

class _MetadataPreviewState extends State<_MetadataPreview> {
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

      final imageExif = await XueHuaMediaInfo.readImageExifFromBytesAsync(
        data: jpegBytes.buffer.asUint8List(),
      );
      final videoTrack = await XueHuaMediaInfo.readVideoMetadataFromBytesAsync(
        data: movBytes.buffer.asUint8List(),
      );

      setState(() {
        _output =
            '''
Image EXIF
  Make: ${imageExif.make ?? '-'}
  Model: ${imageExif.model ?? '-'}
  Size: ${imageExif.width ?? '?'} x ${imageExif.height ?? '?'}
  Tags: ${imageExif.entries.length}
  Has embedded video: ${imageExif.hasEmbeddedVideo}

Video metadata
  Make: ${videoTrack.make ?? '-'}
  Model: ${videoTrack.model ?? '-'}
  Size: ${videoTrack.width ?? '?'} x ${videoTrack.height ?? '?'}
  Duration: ${videoTrack.duration ?? '-'}
  Duration (ms): ${videoTrack.durationMs ?? '-'}
  Tags: ${videoTrack.entries.length}
''';
      });
    } catch (error) {
      setState(() {
        _output = 'Failed to read metadata: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(_output, style: const TextStyle(fontSize: 16)),
    );
  }
}
