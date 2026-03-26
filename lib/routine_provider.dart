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

import 'package:flutter/material.dart';

class Item {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
  });
}

class RestockProvider extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item newItem) {
    final index = _items.indexWhere((i) => i.id == newItem.id);

    if (index >= 0) {
      _items[index] = Item(
        id: newItem.id,
        name: newItem.name,
        quantity: _items[index].quantity + newItem.quantity,
        price: newItem.price,
        category: newItem.category,
      );
    } else {
      _items.add(newItem);
    }

    notifyListeners();
  }

  double get totalCost {
    return _items.fold(0, (sum, i) => sum + (i.price * i.quantity));
  }

  Map<String, int> get categoryBreakdown {
    final Map<String, int> map = {};

    for (var item in _items) {
      map[item.category] = (map[item.category] ?? 0) + 1;
    }

    return map;
  }
}
