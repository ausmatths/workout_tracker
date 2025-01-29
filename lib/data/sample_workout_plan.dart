import '../models/exercise.dart';
import '../models/unit.dart';
import '../models/workout_plan.dart';

final sampleWorkoutPlan = WorkoutPlan(
  name: 'Mixed Sports Training',
  exercises: [
    Exercise(
        name: 'Basketball Free Throws',
        targetOutput: 10,
        unit: Unit.repetitions),
    Exercise(name: 'Swimming Laps', targetOutput: 500, unit: Unit.meters),
    Exercise(name: 'Tennis Practice', targetOutput: 1800, unit: Unit.seconds),
    Exercise(
        name: 'Soccer Ball Juggling', targetOutput: 30, unit: Unit.repetitions),
    Exercise(name: 'Sprint Training', targetOutput: 100, unit: Unit.meters),
    Exercise(
        name: 'Table Tennis Rally', targetOutput: 50, unit: Unit.repetitions),
    Exercise(name: 'Jump Rope', targetOutput: 300, unit: Unit.seconds),
  ],
);
