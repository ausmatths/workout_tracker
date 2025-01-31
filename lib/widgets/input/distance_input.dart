import 'package:flutter/material.dart';
import '../../models/exercise.dart';

class DistanceInput extends StatefulWidget {
  final Exercise exercise;
  final ValueChanged<double> onChanged;

  const DistanceInput({
    Key? key,
    required this.exercise,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DistanceInput> createState() => _DistanceInputState();
}

class _DistanceInputState extends State<DistanceInput> {
  final TextEditingController _controller = TextEditingController();
  double _currentValue = 0;
  bool _isEditingManually = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double value) {
    if (value < 0) value = 0;
    setState(() {
      _currentValue = value;
      if (!_isEditingManually) {
        _controller.text = value.toString();
      }
    });
    widget.onChanged(value);
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
              'Target: ${widget.exercise.targetOutput} meters',
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
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Distance',
                      suffixText: 'meters',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      _isEditingManually = true;
                      _currentValue = double.tryParse(value) ?? 0;
                      widget.onChanged(_currentValue);
                    },
                    onEditingComplete: () {
                      _isEditingManually = false;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _QuickSetButton(
                    value: 100,
                    isSelected: _currentValue == 100,
                    onTap: () => _updateValue(100),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: _QuickSetButton(
                    value: 200,
                    isSelected: _currentValue == 200,
                    onTap: () => _updateValue(200),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: _QuickSetButton(
                    value: 500,
                    isSelected: _currentValue == 500,
                    onTap: () => _updateValue(500),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: _QuickSetButton(
                    value: 1000,
                    isSelected: _currentValue == 1000,
                    onTap: () => _updateValue(1000),
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

class _QuickSetButton extends StatelessWidget {
  final double value;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickSetButton({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          // Added to ensure text fits
          fit: BoxFit.scaleDown,
          child: Text(
            '${value.toInt()}m',
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
