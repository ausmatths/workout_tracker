import 'package:flutter/material.dart';
import '../models/exercise_result.dart';
import '../models/unit.dart';

class ExerciseResultCard extends StatelessWidget {
  final ExerciseResult result;

  const ExerciseResultCard({
    Key? key,
    required this.result,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final percentageAchieved =
        (result.actualOutput / result.exercise.targetOutput * 100).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              result.isSuccessful
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getExerciseIcon(result.exercise.name),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.exercise.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target: ${result.exercise.targetOutput} ${_getUnitString(result.exercise.unit)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: result.isSuccessful
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percentageAchieved%',
                    style: TextStyle(
                      color: result.isSuccessful
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: result.actualOutput / result.exercise.targetOutput,
                backgroundColor: Colors.grey[200],
                color: result.isSuccessful ? Colors.green : Colors.red,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Achieved: ${result.actualOutput} ${_getUnitString(result.exercise.unit)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
