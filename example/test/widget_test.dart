import 'package:flutter_test/flutter_test.dart';
import 'package:xue_hua_media_info_example/main.dart';

void main() {
  testWidgets('shows the metadata preview page', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.text('xue_hua_media_info 2.0'), findsOneWidget);
    await tester.pump();
  });
}
