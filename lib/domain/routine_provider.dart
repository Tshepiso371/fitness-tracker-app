import 'package:flutter/foundation.dart';
import '../data/routine_repository.dart';
import '../models/exercise.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;

  List<Exercise> _routine = [];

  List<Exercise> get routine => _routine;

  RoutineProvider(this._repository) {
    _init();
  }

  Future<void> _init() async {
    _routine = await _repository.loadRoutine();
    notifyListeners();
  }

  Future<void> addExercise(Exercise e) async {
    _routine.add(e);
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }

  Future<void> removeExercise(String id) async {
    _routine.removeWhere((e) => e.id == id);
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }
}