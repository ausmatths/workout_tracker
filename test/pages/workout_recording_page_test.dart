import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/exercise_result.dart';
import 'package:workout_tracker/models/unit.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_plan.dart';
import 'package:workout_tracker/pages/workout_history_page.dart';
import 'package:workout_tracker/pages/workout_recording_page.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/widgets/exercise_result_card.dart';
import 'package:workout_tracker/widgets/input/distance_input.dart';
import 'package:workout_tracker/widgets/input/duration_input.dart';
import 'package:workout_tracker/widgets/input/repetition_input.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/pages/workout_details_page.dart';
import 'package:workout_tracker/widgets/workout_card.dart';
import 'package:workout_tracker/widgets/performance_badge.dart';

void main() {
  group('WorkoutRecordingPage', () {
    String _getUnitString(Unit unit) {
      switch (unit) {
        case Unit.seconds:
          return 'sec';
        case Unit.repetitions:
          return 'reps';
        case Unit.meters:
          return 'm';
      }
    }

    IconData _getExerciseIcon(String exerciseName) {
      switch (exerciseName.toLowerCase()) {
        case 'basketball free throws':
          return Icons.sports_basketball;
        case 'swimming laps':
          return Icons.pool;
        case 'tennis practice':
          return Icons.sports_tennis;
        case 'soccer ball juggling':
          return Icons.sports_soccer;
        case 'sprint training':
          return Icons.directions_run;
        case 'table tennis rally':
          return Icons.sports;
        default:
          return Icons.fitness_center;
      }
    }

    late WorkoutPlan testWorkoutPlan;

    setUp(() {
      testWorkoutPlan = WorkoutPlan(
        name: 'Mixed Sports Training',
        exercises: [
          Exercise(
            name: 'Basketball Free Throws',
            targetOutput: 10,
            unit: Unit.repetitions,
          ),
          Exercise(
            name: 'Swimming Laps',
            targetOutput: 500,
            unit: Unit.meters,
          ),
          Exercise(
            name: 'Tennis Practice',
            targetOutput: 1800,
            unit: Unit.seconds,
          ),
          Exercise(
            name: 'Soccer Ball Juggling',
            targetOutput: 30,
            unit: Unit.repetitions,
          ),
          Exercise(
            name: 'Sprint Training',
            targetOutput: 100,
            unit: Unit.meters,
          ),
          Exercise(
            name: 'Table Tennis Rally',
            targetOutput: 50,
            unit: Unit.repetitions,
          ),
          Exercise(
            name: 'Jump Rope',
            targetOutput: 300,
            unit: Unit.seconds,
          ),
        ],
      );
    });

    Widget createWorkoutRecordingPage() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WorkoutProvider(),
          child: WorkoutRecordingPage(
            workoutPlan: testWorkoutPlan,
          ),
        ),
      );
    }

    testWidgets(
      'shows a separate input for each exercise in the workout plan',
      (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));

        await tester.pumpWidget(createWorkoutRecordingPage());
        await tester.pumpAndSettle();

        for (final exercise in testWorkoutPlan.exercises) {
          await tester.dragUntilVisible(
            find.byKey(ValueKey(exercise.name)),
            find.byType(ListView),
            const Offset(0, -100),
          );
          await tester.pumpAndSettle();

          expect(find.byKey(ValueKey(exercise.name)), findsOneWidget);

          switch (exercise.unit) {
            case Unit.repetitions:
              expect(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is RepetitionInput &&
                      widget.exercise.name == exercise.name,
                ),
                findsOneWidget,
              );
              break;
            case Unit.meters:
              expect(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is DistanceInput &&
                      widget.exercise.name == exercise.name,
                ),
                findsOneWidget,
              );
              break;
            case Unit.seconds:
              expect(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is DurationInput &&
                      widget.exercise.name == exercise.name,
                ),
                findsOneWidget,
              );
              break;
          }
        }

        await tester.dragUntilVisible(
          find.byKey(ValueKey(testWorkoutPlan.exercises.first.name)),
          find.byType(ListView),
          const Offset(0, 100),
        );
        await tester.pumpAndSettle();

        int repetitionCount = 0;
        int distanceCount = 0;
        int durationCount = 0;

        for (final exercise in testWorkoutPlan.exercises) {
          await tester.dragUntilVisible(
            find.byKey(ValueKey(exercise.name)),
            find.byType(ListView),
            const Offset(0, -100),
          );
          await tester.pumpAndSettle();

          switch (exercise.unit) {
            case Unit.repetitions:
              repetitionCount++;
              break;
            case Unit.meters:
              distanceCount++;
              break;
            case Unit.seconds:
              durationCount++;
              break;
          }
        }

        expect(repetitionCount, 3);
        expect(distanceCount, 2);
        expect(durationCount, 2);
      },
    );

    testWidgets(
      'adds Workout to shared state when user completes workout',
      (WidgetTester tester) async {
        late Workout addedWorkout;
        final workoutProvider = WorkoutProvider();
        workoutProvider.addListener(() {
          if (workoutProvider.workouts.isNotEmpty) {
            addedWorkout = workoutProvider.workouts.last;
          }
        });

        await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider.value(
            value: workoutProvider,
            child: WorkoutRecordingPage(
              workoutPlan: testWorkoutPlan,
            ),
          ),
        ));

        final Map<String, double> expectedValues = {};

        for (final exercise in testWorkoutPlan.exercises) {
          await tester.dragUntilVisible(
            find.byKey(ValueKey(exercise.name)),
            find.byType(ListView),
            const Offset(0, -100),
          );
          await tester.pumpAndSettle();

          switch (exercise.unit) {
            case Unit.repetitions:
              final textField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.byType(TextField),
              );
              await tester.enterText(textField, '10');
              expectedValues[exercise.name] = 10.0;
              break;

            case Unit.meters:
              final textField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.byType(TextField),
              );
              await tester.enterText(textField, '500');
              expectedValues[exercise.name] = 500.0;
              break;

            case Unit.seconds:
              final minutesField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.widgetWithText(TextField, 'Minutes'),
              );
              final secondsField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.widgetWithText(TextField, 'Seconds'),
              );

              await tester.enterText(minutesField, '1');
              await tester.enterText(secondsField, '30');
              expectedValues[exercise.name] = 90.0;
              break;
          }
          await tester.pumpAndSettle();
        }

        final completeButton = find.byIcon(Icons.check);
        expect(completeButton, findsOneWidget);
        await tester.tap(completeButton);
        await tester.pumpAndSettle();

        expect(find.text('Complete Workout'), findsOneWidget);

        final dialogCompleteButton =
            find.widgetWithText(FilledButton, 'Complete');
        await tester.tap(dialogCompleteButton);
        await tester.pumpAndSettle();

        expect(workoutProvider.workouts.length, 1);
        expect(addedWorkout.results.length, testWorkoutPlan.exercises.length);

        for (final result in addedWorkout.results) {
          final expectedValue = expectedValues[result.exercise.name];
          expect(result.actualOutput, expectedValue,
              reason:
                  'Exercise ${result.exercise.name} should have value $expectedValue but was ${result.actualOutput}');
        }

        expect(find.byType(WorkoutRecordingPage), findsNothing);
      },
    );

    testWidgets(
      'shows multiple entries when there are multiple Workouts in shared state',
      (WidgetTester tester) async {
        final testWorkouts = [
          Workout(
            date: DateTime(2025, 1, 14),
            results: [
              ExerciseResult(
                exercise: Exercise(
                  name: 'Basketball Free Throws',
                  targetOutput: 10,
                  unit: Unit.repetitions,
                ),
                actualOutput: 10,
              ),
              ExerciseResult(
                exercise: Exercise(
                  name: 'Swimming Laps',
                  targetOutput: 500,
                  unit: Unit.meters,
                ),
                actualOutput: 500,
              ),
            ],
          ),
          Workout(
            date: DateTime(2025, 1, 13),
            results: [
              ExerciseResult(
                exercise: Exercise(
                  name: 'Tennis Practice',
                  targetOutput: 1800,
                  unit: Unit.seconds,
                ),
                actualOutput: 1500,
              ),
              ExerciseResult(
                exercise: Exercise(
                  name: 'Soccer Ball Juggling',
                  targetOutput: 30,
                  unit: Unit.repetitions,
                ),
                actualOutput: 20,
              ),
            ],
          ),
        ];

        final workoutProvider = WorkoutProvider();
        for (final workout in testWorkouts) {
          workoutProvider.addWorkout(workout);
        }

        // Build widget
        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: workoutProvider,
              child: const WorkoutHistoryPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Workout History'), findsOneWidget);

        expect(find.byType(PerformanceBadge), findsOneWidget);

        expect(find.byType(WorkoutCard), findsNWidgets(testWorkouts.length));

        for (int i = 0; i < testWorkouts.length; i++) {
          final workout = testWorkouts[i];

          expect(
            find.text(DateFormat.yMMMd().format(workout.date)),
            findsOneWidget,
          );

          expect(
            find.byWidgetPredicate(
              (widget) => widget is WorkoutCard && widget.workout == workout,
            ),
            findsOneWidget,
          );

          final successRate =
              (workout.successfulExercises / workout.totalExercises * 100)
                  .round();
          expect(
            find.descendant(
              of: find.byWidgetPredicate(
                (widget) => widget is WorkoutCard && widget.workout == workout,
              ),
              matching: find.text('$successRate%'),
            ),
            findsOneWidget,
          );
        }

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        final firstCard = find.byType(WorkoutCard).first;
        await tester.tap(firstCard);
        await tester.pumpAndSettle();

        expect(find.byType(WorkoutDetailsPage), findsOneWidget);
      },
    );

    testWidgets(
      'shows specifics of exercises and their actual outputs',
      (WidgetTester tester) async {
        final testWorkout = Workout(
          date: DateTime(2025, 1, 14),
          results: [
            ExerciseResult(
              exercise: Exercise(
                name: 'Basketball Free Throws',
                targetOutput: 10,
                unit: Unit.repetitions,
              ),
              actualOutput: 8,
            ),
            ExerciseResult(
              exercise: Exercise(
                name: 'Swimming Laps',
                targetOutput: 500,
                unit: Unit.meters,
              ),
              actualOutput: 450,
            ),
            ExerciseResult(
              exercise: Exercise(
                name: 'Tennis Practice',
                targetOutput: 1800,
                unit: Unit.seconds,
              ),
              actualOutput: 1600,
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutDetailsPage(workout: testWorkout),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Workout - ${DateFormat.yMMMd().format(testWorkout.date)}'),
          findsOneWidget,
        );

        expect(find.byType(ExerciseResultCard),
            findsNWidgets(testWorkout.results.length));

        for (final result in testWorkout.results) {
          expect(find.text(result.exercise.name), findsOneWidget);

          expect(
            find.text(
                'Target: ${result.exercise.targetOutput} ${_getUnitString(result.exercise.unit)}'),
            findsOneWidget,
          );

          expect(
            find.text(
                'Achieved: ${result.actualOutput} ${_getUnitString(result.exercise.unit)}'),
            findsOneWidget,
          );

          final percentageAchieved =
              (result.actualOutput / result.exercise.targetOutput * 100)
                  .round();
          expect(find.text('$percentageAchieved%'), findsOneWidget);

          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Icon &&
                  widget.icon == _getExerciseIcon(result.exercise.name),
            ),
            findsOneWidget,
          );

          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is LinearProgressIndicator &&
                  widget.value ==
                      result.actualOutput / result.exercise.targetOutput,
            ),
            findsOneWidget,
          );
        }
      },
    );
  });
}
