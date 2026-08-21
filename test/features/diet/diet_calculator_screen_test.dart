import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_pro/features/diet/diet_calculator_screen.dart';
import 'package:fitness_pro/theme/app_theme.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const DietCalculatorScreen(),
      ),
    );
  }

  testWidgets('filling the form and tapping Calculate shows results', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('BMR'), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, 'Age (years)'), '28');
    await tester.enterText(find.widgetWithText(TextFormField, 'Height (cm)'), '178');
    await tester.enterText(find.widgetWithText(TextFormField, 'Weight (kg)'), '75');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pump();

    // Male, 28y, 178cm, 75kg, moderate activity, maintain:
    // BMR = 10*75 + 6.25*178 - 5*28 + 5 = 750 + 1112.5 - 140 + 5 = 1727.5
    // TDEE = 1727.5 * 1.55 = 2677.625 -> calorie target rounds to 2678
    expect(find.text('1728 kcal'), findsOneWidget); // BMR rounds to 1728
    // TDEE and calorie target are equal for "maintain", so the same text
    // renders twice (TDEE row + emphasized calorie-target row).
    expect(find.text('2678 kcal'), findsNWidgets(2));
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Carbs'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
  });

  testWidgets('invalid input blocks calculation and shows validation errors', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Age (years)'), '999');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pump();

    expect(find.textContaining('Must be between'), findsWidgets);
    expect(find.text('BMR'), findsNothing);
  });
}
