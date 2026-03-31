import 'package:flutter/material.dart';
import '../data/exercise_api_repository.dart';
import '../data/models/api_exercise.dart';

class ExerciseSearchProvider extends ChangeNotifier {
  final ExerciseApiRepository _repository;

  ExerciseSearchProvider(this._repository);

  List<ApiExercise> _results = [];
  bool _isLoading = false;
  String? _error;
  String _lastQuery = '';

  List<ApiExercise> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get hasResults => _results.isNotEmpty;
  bool get hasError => _error != null;

  Future<void> searchExercises(String muscle) async {
    final query = muscle.trim().toLowerCase();

    if (query.isEmpty) return;

    _lastQuery = query;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await _repository.searchExercises(query);
    } catch (e) {
      _error = e.toString();
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    await searchExercises(_lastQuery);
  }

  void clear() {
    _results = [];
    _error = null;
    _lastQuery = '';
    notifyListeners();
  }
}