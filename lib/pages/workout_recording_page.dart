import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/exercise_result.dart';
import '../models/unit.dart';
import '../models/workout.dart';
import '../models/workout_plan.dart';
import '../providers/workout_provider.dart';
import '../widgets/input/distance_input.dart';
import '../widgets/input/duration_input.dart';
import '../widgets/input/repetition_input.dart';
import '../widgets/performance_badge.dart';

class WorkoutRecordingPage extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutRecordingPage({
    Key? key,
    required this.workoutPlan,
  }) : super(key: key);

  @override
  State<WorkoutRecordingPage> createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final Map<Exercise, double> _results = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _getCompletionPercentage() {
    return (_results.length / widget.workoutPlan.exercises.length) * 100;
  }

  Widget _buildInputForExercise(Exercise exercise) {
    switch (exercise.unit) {
      case Unit.seconds:
        return DurationInput(
          key: ValueKey(exercise.name),
          exercise: exercise,
          onChanged: (value) => setState(() => _results[exercise] = value),
        );
      case Unit.repetitions:
        return RepetitionInput(
          key: ValueKey(exercise.name),
          exercise: exercise,
          onChanged: (value) => setState(() => _results[exercise] = value),
        );
      case Unit.meters:
        return DistanceInput(
          key: ValueKey(exercise.name),
          exercise: exercise,
          onChanged: (value) => setState(() => _results[exercise] = value),
        );
    }
  }

  void _showCompletionDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Complete Workout'),
        content: const Text('Are you sure you want to finish this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final workout = Workout(
                date: DateTime.now(),
                results: _results.entries
                    .map((e) => ExerciseResult(
                          exercise: e.key,
                          actualOutput: e.value,
                        ))
                    .toList(),
              );
              // Get provider using root context
              context.read<WorkoutProvider>().addWorkout(workout);
              Navigator.of(dialogContext).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to previous page
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _finishWorkout() {
    if (_results.length != widget.workoutPlan.exercises.length) {
      final remaining = widget.workoutPlan.exercises.length - _results.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete remaining $remaining exercise${remaining > 1 ? 's' : ''}',
          ),
          action: SnackBarAction(
            label: 'Show Next',
            onPressed: () {
              final nextIncomplete = widget.workoutPlan.exercises
                  .firstWhere((exercise) => !_results.containsKey(exercise));
              final index =
                  widget.workoutPlan.exercises.indexOf(nextIncomplete);
              _scrollToIndex(index);
            },
          ),
        ),
      );
      return;
    }

    _showCompletionDialog();
  }

  void _scrollToNext() {
    final nextIncomplete = widget.workoutPlan.exercises
        .firstWhere((exercise) => !_results.containsKey(exercise));
    final index = widget.workoutPlan.exercises.indexOf(nextIncomplete);
    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    final itemHeight = 200.0; // Approximate height of each exercise card
    _scrollController.animateTo(
      index * itemHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final completionPercentage = _getCompletionPercentage();
    final isComplete = completionPercentage == 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutPlan.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: completionPercentage / 100,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              isComplete ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${completionPercentage.toInt()}%',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${_results.length}/${widget.workoutPlan.exercises.length} exercises',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: PerformanceBadge(),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: widget.workoutPlan.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.workoutPlan.exercises[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildInputForExercise(exercise),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isComplete
          ? FloatingActionButton.extended(
              onPressed: _finishWorkout,
              icon: const Icon(Icons.check),
              label: const Text('Complete'),
            )
          : FloatingActionButton(
              onPressed: _scrollToNext,
              child: const Icon(Icons.arrow_downward),
            ),
    );
  }
}
