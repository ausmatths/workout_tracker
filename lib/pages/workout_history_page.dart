import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/pages/workout_details_page.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';
import '../widgets/performance_badge.dart';
import 'workout_recording_page.dart';
import '../data/sample_workout_plan.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: Column(
        children: [
          const PerformanceBadge(),
          Expanded(
            child: Consumer<WorkoutProvider>(
              builder: (context, provider, child) {
                final workouts = provider.workouts;

                if (workouts.isEmpty) {
                  return const Center(
                    child: Text('No workouts recorded yet'),
                  );
                }

                return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return WorkoutCard(
                      key:
                          ValueKey(workout.date.toString()), // Add a unique key
                      workout: workout,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetailsPage(workout: workout),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutRecordingPage(
                workoutPlan: sampleWorkoutPlan,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
