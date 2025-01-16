import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/workout_card.dart';
import 'workout_details_page.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: ListView.builder(
        itemCount: mockWorkouts.length,
        itemBuilder: (context, index) {
          final workout = mockWorkouts[index];
          return WorkoutCard(
            workout: workout,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailsPage(workout: workout),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
