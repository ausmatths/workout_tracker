import 'package:flutter/material.dart';
import '../../models/exercise.dart';

class RepetitionInput extends StatefulWidget {
  final Exercise exercise;
  final ValueChanged<double> onChanged;

  const RepetitionInput({
    Key? key,
    required this.exercise,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RepetitionInput> createState() => _RepetitionInputState();
}

class _RepetitionInputState extends State<RepetitionInput> {
  final TextEditingController _controller = TextEditingController();
  double _currentValue = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${widget.exercise.targetOutput.toInt()} reps',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Repetitions',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      _currentValue = double.tryParse(value) ?? 0;
                      widget.onChanged(_currentValue);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _currentValue++;
                        _controller.text = _currentValue.toInt().toString();
                        widget.onChanged(_currentValue);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _currentValue > 0
                          ? () {
                              _currentValue--;
                              _controller.text =
                                  _currentValue.toInt().toString();
                              widget.onChanged(_currentValue);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
