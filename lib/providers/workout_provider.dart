import 'package:flutter/foundation.dart';
import '../models/workout.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => List.unmodifiable(_workouts);

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  List<Workout> getRecentWorkouts() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _workouts
        .where((workout) => workout.date.isAfter(sevenDaysAgo))
        .toList();
  }

  double calculatePerformanceScore() {
    final recentWorkouts = getRecentWorkouts();
    if (recentWorkouts.isEmpty) return 0;

    int totalResults = 0;
    int successfulResults = 0;
    double totalPercentage = 0;

    for (var workout in recentWorkouts) {
      for (var result in workout.results) {
        totalResults++;

        // Calculate percentage achieved for this result
        double percentage =
            (result.actualOutput / result.exercise.targetOutput) * 100;
        totalPercentage += percentage;

        if (result.isSuccessful) {
          successfulResults++;
        }
      }
    }

    if (totalResults == 0) return 0;

    // Combine completion rate and average percentage achieved
    double completionRate = (successfulResults / totalResults) * 100;
    double averagePercentage = totalPercentage / totalResults;

    // Weight completion rate more heavily than over achievement
    return (completionRate * 0.6 + averagePercentage * 0.4).clamp(0.0, 100.0);
  }
}
