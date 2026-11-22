import 'package:flutter_test/flutter_test.dart';
import 'package:ping_pong/main.dart';

void main() {
  testWidgets('App renders Ping-Pong game without error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(GameScreen), findsOneWidget);
  });
}
