import 'package:flutter_test/flutter_test.dart';
import 'package:dhanvantri_healthcare/main.dart';

void main() {
  testWidgets('Dhanvantri app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DhanvantriApp());

    // Verify that splash screen loads
    expect(find.text('DHANVANTARI'), findsOneWidget);
  });
}
