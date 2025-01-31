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
        // Set a larger surface size to ensure more widgets are visible
        await tester.binding.setSurfaceSize(const Size(400, 800));

        // Build the widget
        await tester.pumpWidget(createWorkoutRecordingPage());
        await tester.pumpAndSettle(); // Wait for animations to complete

        // Verify each exercise has its corresponding input widget
        for (final exercise in testWorkoutPlan.exercises) {
          // Scroll until the exercise is visible
          await tester.dragUntilVisible(
            find.byKey(ValueKey(exercise.name)),
            find.byType(ListView),
            const Offset(0, -100),
          );
          await tester.pumpAndSettle();

          // Now verify the widget
          expect(find.byKey(ValueKey(exercise.name)), findsOneWidget);

          // Verify correct input type is shown for each exercise
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

        // Scroll back to top to count total widgets
        await tester.dragUntilVisible(
          find.byKey(ValueKey(testWorkoutPlan.exercises.first.name)),
          find.byType(ListView),
          const Offset(0, 100),
        );
        await tester.pumpAndSettle();

        // Count the widgets of each type
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
        // Set up a WorkoutProvider with a listener to track added workouts
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

        // Map to store expected values for verification
        final Map<String, double> expectedValues = {};

        // Fill out each exercise
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
              // Find minutes and seconds fields
              final minutesField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.widgetWithText(TextField, 'Minutes'),
              );
              final secondsField = find.descendant(
                of: find.byKey(ValueKey(exercise.name)),
                matching: find.widgetWithText(TextField, 'Seconds'),
              );

              // Enter 1 minute and 30 seconds
              await tester.enterText(minutesField, '1');
              await tester.enterText(secondsField, '30');
              expectedValues[exercise.name] =
                  90.0; // 1 minute 30 seconds = 90 seconds
              break;
          }
          await tester.pumpAndSettle();
        }

        // Complete the workout
        final completeButton = find.byIcon(Icons.check);
        expect(completeButton, findsOneWidget);
        await tester.tap(completeButton);
        await tester.pumpAndSettle();

        expect(find.text('Complete Workout'), findsOneWidget);

        final dialogCompleteButton =
            find.widgetWithText(FilledButton, 'Complete');
        await tester.tap(dialogCompleteButton);
        await tester.pumpAndSettle();

        // Verify workout was added
        expect(workoutProvider.workouts.length, 1);
        expect(addedWorkout.results.length, testWorkoutPlan.exercises.length);

        // Verify each exercise result matches expected value
        for (final result in addedWorkout.results) {
          final expectedValue = expectedValues[result.exercise.name];
          expect(result.actualOutput, expectedValue,
              reason:
                  'Exercise ${result.exercise.name} should have value $expectedValue but was ${result.actualOutput}');
        }

        // Verify navigation
        expect(find.byType(WorkoutRecordingPage), findsNothing);
      },
    );

    testWidgets(
      'shows multiple entries when there are multiple Workouts in shared state',
      (WidgetTester tester) async {
        // Set up test data with different success rates
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
                actualOutput: 10, // Successfully completed
              ),
              ExerciseResult(
                exercise: Exercise(
                  name: 'Swimming Laps',
                  targetOutput: 500,
                  unit: Unit.meters,
                ),
                actualOutput: 500, // Successfully completed
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
                actualOutput: 1500, // Not completed successfully
              ),
              ExerciseResult(
                exercise: Exercise(
                  name: 'Soccer Ball Juggling',
                  targetOutput: 30,
                  unit: Unit.repetitions,
                ),
                actualOutput: 20, // Not completed successfully
              ),
            ],
          ),
        ];

        // Create and populate provider
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

        // Verify AppBar title
        expect(find.text('Workout History'), findsOneWidget);

        // Verify PerformanceBadge is shown
        expect(find.byType(PerformanceBadge), findsOneWidget);

        // Verify all workout cards are shown
        expect(find.byType(WorkoutCard), findsNWidgets(testWorkouts.length));

        // Verify each workout's data is displayed
        for (int i = 0; i < testWorkouts.length; i++) {
          final workout = testWorkouts[i];

          // Verify date
          expect(
            find.text(DateFormat.yMMMd().format(workout.date)),
            findsOneWidget,
          );

          // Verify workout card content
          expect(
            find.byWidgetPredicate(
              (widget) => widget is WorkoutCard && widget.workout == workout,
            ),
            findsOneWidget,
          );

          // Find the specific card's success rate using widget ancestor finder
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

        // Verify add workout button is present
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        // Verify navigation works
        final firstCard = find.byType(WorkoutCard).first;
        await tester.tap(firstCard);
        await tester.pumpAndSettle();

        // Verify we navigated to details page
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

        // Verify page title with date
        expect(
          find.text('Workout - ${DateFormat.yMMMd().format(testWorkout.date)}'),
          findsOneWidget,
        );

        // Verify all exercise result cards are shown
        expect(find.byType(ExerciseResultCard),
            findsNWidgets(testWorkout.results.length));

        // Verify each exercise's details
        for (final result in testWorkout.results) {
          // Exercise name
          expect(find.text(result.exercise.name), findsOneWidget);

          // Target output
          expect(
            find.text(
                'Target: ${result.exercise.targetOutput} ${_getUnitString(result.exercise.unit)}'),
            findsOneWidget,
          );

          // Actual output
          expect(
            find.text(
                'Achieved: ${result.actualOutput} ${_getUnitString(result.exercise.unit)}'),
            findsOneWidget,
          );

          // Percentage achieved
          final percentageAchieved =
              (result.actualOutput / result.exercise.targetOutput * 100)
                  .round();
          expect(find.text('$percentageAchieved%'), findsOneWidget);

          // Exercise icon
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Icon &&
                  widget.icon == _getExerciseIcon(result.exercise.name),
            ),
            findsOneWidget,
          );

          // Verify progress indicator exists
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
