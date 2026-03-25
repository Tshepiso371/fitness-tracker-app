import 'package:flutter/material.dart';
import '../models/exercise.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Exercise> _routine = [];

  List<Exercise> get routine => _routine;

  int get exerciseCount => _routine.length;

  int get totalSets =>
      _routine.fold(0, (sum, e) => sum + e.sets);

  double get totalVolume =>
      _routine.fold(0, (sum, e) => sum + e.volume);

  bool isInRoutine(String id) {
    return _routine.any((e) => e.id == id);
  }

  Map<String, int> get muscleGroupBreakdown {
    final Map<String, int> map = {};

    for (var e in _routine) {
      map[e.muscleGroup] =
          (map[e.muscleGroup] ?? 0) + 1;
    }

    return map;
  }

  void addExercise(Exercise exercise) {
    if (isInRoutine(exercise.id)) return;

    _routine.add(exercise);
    notifyListeners();
  }

  void removeExercise(String id) {
    _routine.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clearRoutine() {
    _routine.clear();
    notifyListeners();
  }
}