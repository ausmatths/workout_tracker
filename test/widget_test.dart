// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/sample_workout_plan.dart';
import 'package:workout_tracker/models/exercise_result.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/pages/workout_history_page.dart';
import 'package:workout_tracker/pages/workout_recording_page.dart';
import 'package:workout_tracker/providers/workout_provider.dart';

void main() {
  late WorkoutProvider provider;

  setUp(() {
    provider = WorkoutProvider();
  });

  Widget createTestApp(Widget child) {
    return MaterialApp(
      home: ChangeNotifierProvider.value(
        value: provider,
        builder: (context, child) => child!,
        child: child,
      ),
    );
  }

  group('WorkoutHistoryPage Tests', () {
    testWidgets('shows empty state', (tester) async {
      await tester.pumpWidget(createTestApp(const WorkoutHistoryPage()));
      await tester.pumpAndSettle();

      expect(find.text('No workouts recorded yet'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows workout list when workouts exist', (tester) async {
      provider.addWorkout(
        Workout(
          date: DateTime.now(),
          results: [
            ExerciseResult(
              exercise: sampleWorkoutPlan.exercises[0],
              actualOutput: 10,
            ),
          ],
        ),
      );

      await tester.pumpWidget(createTestApp(const WorkoutHistoryPage()));
      await tester.pumpAndSettle();

      expect(find.text('No workouts recorded yet'), findsNothing);
      expect(find.text('1/1 exercises completed successfully'), findsOneWidget);
    });
  });

  group('WorkoutRecordingPage Tests', () {
    testWidgets('shows initial state', (tester) async {
      await tester.pumpWidget(
        createTestApp(WorkoutRecordingPage(workoutPlan: sampleWorkoutPlan)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Progress: 0%'), findsOneWidget);
      expect(
        find.text('0/${sampleWorkoutPlan.exercises.length} exercises'),
        findsOneWidget,
      );
    });

    testWidgets('records exercise input', (tester) async {
      await tester.pumpWidget(
        createTestApp(WorkoutRecordingPage(workoutPlan: sampleWorkoutPlan)),
      );
      await tester.pumpAndSettle();

      // Find and fill first exercise
      final firstExercise = sampleWorkoutPlan.exercises[0];
      final textField = find
          .descendant(
            of: find.ancestor(
              of: find.text(firstExercise.name),
              matching: find.byType(Card),
            ),
            matching: find.byType(TextField),
          )
          .first;

      await tester.enterText(textField, '10');
      await tester.pump();

      // Verify progress updates
      final expectedProgress =
          (100 / sampleWorkoutPlan.exercises.length).round();
      expect(find.text('Progress: $expectedProgress%'), findsOneWidget);
      expect(
        find.text('1/${sampleWorkoutPlan.exercises.length} exercises'),
        findsOneWidget,
      );
    });

    testWidgets('shows completion dialog', (tester) async {
      await tester.pumpWidget(
        createTestApp(WorkoutRecordingPage(workoutPlan: sampleWorkoutPlan)),
      );
      await tester.pumpAndSettle();

      // Fill all exercises
      for (final exercise in sampleWorkoutPlan.exercises) {
        final textField = find
            .descendant(
              of: find.ancestor(
                of: find.text(exercise.name),
                matching: find.byType(Card),
              ),
              matching: find.byType(TextField),
            )
            .first;

        await tester.enterText(textField, '10');
        await tester.pump();
      }

      // Verify 100% completion
      expect(find.text('Progress: 100%'), findsOneWidget);

      // Tap complete FAB
      await tester.tap(find.byIcon(Icons.check).first);
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Complete Workout'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Complete'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Cancel'),
        ),
        findsOneWidget,
      );
    });
  });
}
