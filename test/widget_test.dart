import 'package:flutter_test/flutter_test.dart';
import 'package:readspeed/main.dart';

void main() {
  testWidgets('ReadSpeed app boots to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const ReadSpeedApp());
    await tester.pump();
    expect(find.text('ReadSpeed'), findsWidgets);
  });
}
