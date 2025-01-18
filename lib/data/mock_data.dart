import '../models/exercise.dart';
import '../models/exercise_result.dart';
import '../models/unit.dart';
import '../models/workout.dart';

final mockWorkouts = [
  Workout(
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
        actualOutput: 550,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Tennis Practice',
          targetOutput: 1800,
          unit: Unit.seconds,
        ),
        actualOutput: 1920,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 13),
    results: [
      ExerciseResult(
        exercise: Exercise(
          name: 'Soccer Ball Juggling',
          targetOutput: 30,
          unit: Unit.repetitions,
        ),
        actualOutput: 35,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Sprint Training',
          targetOutput: 100,
          unit: Unit.meters,
        ),
        actualOutput: 100,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Table Tennis Rally',
          targetOutput: 50,
          unit: Unit.repetitions,
        ),
        actualOutput: 45,
      ),
    ],
  ),
];
