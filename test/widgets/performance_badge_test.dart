import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/exercise_result.dart';
import 'package:workout_tracker/models/unit.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/widgets/performance_badge.dart';

void main() {
  group('PerformanceBadge', () {
    late WorkoutProvider workoutProvider;

    setUp(() {
      workoutProvider = WorkoutProvider();
    });

    Widget createPerformanceBadge() {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider.value(
            value: workoutProvider,
            child: const PerformanceBadge(),
          ),
        ),
      );
    }

    testWidgets(
      'displays metric based on recent workouts',
      (WidgetTester tester) async {
        final workouts = [
          Workout(
            date: DateTime.now().subtract(const Duration(days: 1)),
            results: [
              ExerciseResult(
                exercise: Exercise(
                  name: 'Basketball Free Throws',
                  targetOutput: 10,
                  unit: Unit.repetitions,
                ),
                actualOutput: 10, // 100% success
              ),
            ],
          ),
          Workout(
            date: DateTime.now().subtract(const Duration(days: 2)),
            results: [
              ExerciseResult(
                exercise: Exercise(
                  name: 'Swimming Laps',
                  targetOutput: 500,
                  unit: Unit.meters,
                ),
                actualOutput: 400, // 80% success
              ),
            ],
          ),
        ];

        for (final workout in workouts) {
          workoutProvider.addWorkout(workout);
        }

        await tester.pumpWidget(createPerformanceBadge());
        await tester.pumpAndSettle();

        expect(find.text('Recent Performance'), findsOneWidget);

        expect(
          find.byWidgetPredicate((widget) {
            if (widget is Text) {
              return RegExp(r'\d+\.\d+%').hasMatch(widget.data ?? '');
            }
            return false;
          }),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays default message when no recent workouts exist',
      (WidgetTester tester) async {
        final oldWorkout = Workout(
          date: DateTime.now().subtract(const Duration(days: 8)),
          results: [
            ExerciseResult(
              exercise: Exercise(
                name: 'Basketball Free Throws',
                targetOutput: 10,
                unit: Unit.repetitions,
              ),
              actualOutput: 10,
            ),
          ],
        );

        workoutProvider.addWorkout(oldWorkout);

        await tester.pumpWidget(createPerformanceBadge());
        await tester.pumpAndSettle();

        expect(find.text('Recent Performance'), findsOneWidget);

        expect(find.text('No recent workouts'), findsOneWidget);
      },
    );

    testWidgets(
      'updates when new workouts are added',
      (WidgetTester tester) async {
        await tester.pumpWidget(createPerformanceBadge());
        await tester.pumpAndSettle();

        expect(find.text('No recent workouts'), findsOneWidget);

        final newWorkout = Workout(
          date: DateTime.now(),
          results: [
            ExerciseResult(
              exercise: Exercise(
                name: 'Tennis Practice',
                targetOutput: 1800,
                unit: Unit.seconds,
              ),
              actualOutput: 1800, // 100% success
            ),
          ],
        );

        workoutProvider.addWorkout(newWorkout);
        await tester.pumpAndSettle();

        expect(find.text('No recent workouts'), findsNothing);
        expect(
          find.byWidgetPredicate((widget) {
            if (widget is Text) {
              return RegExp(r'\d+\.\d+%').hasMatch(widget.data ?? '');
            }
            return false;
          }),
          findsOneWidget,
        );
      },
    );
  });
}
