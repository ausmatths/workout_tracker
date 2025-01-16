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
          name: 'Push-ups',
          targetOutput: 20,
          unit: Unit.repetitions,
        ),
        actualOutput: 22,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Plank',
          targetOutput: 60,
          unit: Unit.seconds,
        ),
        actualOutput: 45,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Running',
          targetOutput: 1000,
          unit: Unit.meters,
        ),
        actualOutput: 1200,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 13),
    results: [
      ExerciseResult(
        exercise: Exercise(
          name: 'Squats',
          targetOutput: 15,
          unit: Unit.repetitions,
        ),
        actualOutput: 15,
      ),
      ExerciseResult(
        exercise: Exercise(
          name: 'Wall Sit',
          targetOutput: 30,
          unit: Unit.seconds,
        ),
        actualOutput: 25,
      ),
    ],
  ),
];
