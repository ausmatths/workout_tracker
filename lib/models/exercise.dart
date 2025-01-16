import 'package:workout_tracker/models/unit.dart';

class Exercise {
  final String name;
  final double targetOutput;
  final Unit unit;

  Exercise({
    required this.name,
    required this.targetOutput,
    required this.unit,
  });
}
