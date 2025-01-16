import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../widgets/exercise_result_card.dart';
import 'package:intl/intl.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailsPage({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout - ${DateFormat.yMMMd().format(workout.date)}'),
      ),
      body: ListView.builder(
        itemCount: workout.results.length,
        itemBuilder: (context, index) {
          return ExerciseResultCard(result: workout.results[index]);
        },
      ),
    );
  }
}
