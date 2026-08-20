import 'package:flutter/material.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  runApp(const ExampleApp());
}

/// Root widget of the demo app. / 示例应用根组件。
class ExampleApp extends StatelessWidget {
  /// Creates the example app. / 创建示例应用。
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xue_hua_media_info demo',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3F6CFF),
        useMaterial3: true,
      ),
      home: const MetadataPreviewPage(),
    );
  }
}

/// Loads bundled sample files and shows typed metadata.
/// 加载打包的样例文件并展示类型化元数据。
class MetadataPreviewPage extends StatefulWidget {
  /// Creates the preview page. / 创建预览页。
  const MetadataPreviewPage({super.key});

  @override
  State<MetadataPreviewPage> createState() => _MetadataPreviewPageState();
}

class _MetadataPreviewPageState extends State<MetadataPreviewPage> {
  String _output = 'Loading sample metadata...';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      const jpeg = MediaSource.asset('assets/testdata/exif.jpg');
      const mov = MediaSource.asset('assets/testdata/meta.mov');
      const png = MediaSource.asset('assets/testdata/exif.png');

      final image = await MediaInfo.readImage(jpeg);
      final container = await MediaInfo.readAv(mov);
      final pngMeta = await MediaInfo.readImage(png);

      if (!mounted) {
        return;
      }

      final avLine = switch (container) {
        VideoMetadata(:final duration, :final size, :final make) =>
          'Video  make=${make ?? '-'}  size=$size  duration=$duration',
        AudioMetadata(:final duration, :final sampleRate) =>
          'Audio  duration=$duration  sampleRate=$sampleRate',
      };

      setState(() {
        _output =
            '''
JPEG
  Make: ${image.make ?? '-'}
  Model: ${image.model ?? '-'}
  Size: ${image.size ?? '-'}
  GPS: ${image.gps ?? '-'}
  Motion Photo: ${image.hasMotionPhoto}

PNG
  Size: ${pngMeta.size ?? '-'}
  tEXt: ${pngMeta.pngText.length}

MOV
  $avLine
''';
      });
    } on MediaInfoError catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _output = '${error.code}: ${error.message}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _output = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('xue_hua_media_info 2.0')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _output,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}
