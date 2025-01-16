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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.exercise.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Target: ${result.exercise.targetOutput} ${_getUnitString(result.exercise.unit)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Actual: ${result.actualOutput} ${_getUnitString(result.exercise.unit)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              result.isSuccessful ? Icons.check_circle : Icons.cancel,
              color: result.isSuccessful ? Colors.green : Colors.red,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
