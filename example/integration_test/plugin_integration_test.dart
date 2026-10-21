import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('probes the bundled JPEG asset', (tester) async {
    final kind = await MediaInfo.probe(
      const MediaSource.asset('assets/testdata/exif.jpg'),
    );
    expect(kind, MediaKind.image);
  });
}
