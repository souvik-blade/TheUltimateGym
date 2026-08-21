import 'package:fitness_pro/data/db/app_database.dart';
import 'package:fitness_pro/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers/in_memory_db.dart';

void main() {
  setUp(() async {
    await setUpInMemoryDatabase();
  });

  tearDown(() async {
    await AppDatabase.instance.close();
  });

  testWidgets('fresh install shows the Welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FitnessProApp());
    // WelcomeScreen staggers flutter_animate fade-ins via Future.delayed;
    // advance real/virtual time past the longest delay before settling, or
    // pumpAndSettle returns early (nothing "scheduled" yet) and leaves
    // FakeAsync timers dangling at teardown. See in_memory_db.dart's sibling
    // note for the google_fonts half of this same test-environment issue.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Fitness Pro'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
