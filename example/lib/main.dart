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

      setState(() {
        _output =
            '''
JPEG
${_imageFields(image)}

PNG
${_imageFields(pngMeta)}

MOV
${_avFields(container)}
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
        child: SingleChildScrollView(
          child: SelectableText(
            _output,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }
}

String _fmt(Object? value) => value?.toString() ?? '-';

String _imageFields(ImageMetadata meta) {
  final pngText = meta.pngText.isEmpty
      ? '-'
      : meta.pngText.map((chunk) => '${chunk.key}=${chunk.value}').join(', ');
  final extra = meta.extraTags.isEmpty
      ? '-'
      : meta.extraTags
            .map((tag) => '${tag.name}=${tag.displayValue}')
            .join(', ');
  return '''
  make: ${_fmt(meta.make)}
  model: ${_fmt(meta.model)}
  software: ${_fmt(meta.software)}
  size: ${_fmt(meta.size)}
  orientation: ${_fmt(meta.orientation)}
  dateTimeOriginal: ${_fmt(meta.dateTimeOriginal)}
  dateTimeDigitized: ${_fmt(meta.dateTimeDigitized)}
  dateTimeModified: ${_fmt(meta.dateTimeModified)}
  gps: ${_fmt(meta.gps)}
  hasMotionPhoto: ${meta.hasMotionPhoto}
  pngText: $pngText
  extraTags: $extra''';
}

String _avFields(AvMetadata meta) {
  final extra = switch (meta) {
    VideoMetadata(:final extraTags) || AudioMetadata(:final extraTags) =>
      extraTags.isEmpty
          ? '-'
          : extraTags
                .map((tag) => '${tag.name}=${tag.displayValue}')
                .join(', '),
  };
  return switch (meta) {
    VideoMetadata() =>
      '''
  kind: video
  duration: ${_fmt(meta.duration)}
  size: ${_fmt(meta.size)}
  bitrate: ${_fmt(meta.bitrate)}
  rotationDegrees: ${_fmt(meta.rotationDegrees)}
  make: ${_fmt(meta.make)}
  model: ${_fmt(meta.model)}
  gps: ${_fmt(meta.gps)}
  extraTags: $extra''',
    AudioMetadata() =>
      '''
  kind: audio
  duration: ${_fmt(meta.duration)}
  bitrate: ${_fmt(meta.bitrate)}
  sampleRate: ${_fmt(meta.sampleRate)}
  channelCount: ${_fmt(meta.channelCount)}
  make: ${_fmt(meta.make)}
  model: ${_fmt(meta.model)}
  gps: ${_fmt(meta.gps)}
  extraTags: $extra''',
  };
}
