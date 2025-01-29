import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/exercise.dart';

class DurationInput extends StatefulWidget {
  final Exercise exercise;
  final ValueChanged<double> onChanged;

  const DurationInput({
    Key? key,
    required this.exercise,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends State<DurationInput> {
  int _minutes = 0;
  int _seconds = 0;

  void _updateValue() {
    widget.onChanged(_minutes * 60 + _seconds.toDouble());
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _minutes = int.tryParse(value) ?? 0;
                        _updateValue();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _seconds = int.tryParse(value) ?? 0;
                        _updateValue();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
