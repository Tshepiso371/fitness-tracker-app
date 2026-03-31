import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';

class RoutineRepository {
  static const String _key = 'routine';

  Future<void> saveRoutine(List<Exercise> routine) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = routine.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<Exercise>> loadRoutine() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return [];

      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => Exercise.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearRoutine() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}