import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_pro/main.dart';

void main() {
  testWidgets('HomeScreen renders the Fitness Pro title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FitnessProApp());
    await tester.pumpAndSettle();

    expect(find.text('Fitness Pro'), findsOneWidget);
    expect(find.text('Calculate my targets'), findsOneWidget);
  });
}
