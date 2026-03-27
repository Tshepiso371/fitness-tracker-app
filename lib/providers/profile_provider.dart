import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {


  String _name = "Guest";
  int _age = 0;
  double _weightGoal = 0;


  String _unit = "kg";
  int _restTimer = 60;
  bool _notifications = true;

  String get name => _name;
  int get age => _age;
  double get weightGoal => _weightGoal;

  String get unit => _unit;
  int get restTimer => _restTimer;
  bool get notifications => _notifications;

  ProfileProvider() {
    _loadAll();
  }


  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('profile_name') ?? "Guest";

    _age = prefs.getInt('profile_age') ?? 0;
    if (_age < 0 || _age > 120) _age = 0;

    _weightGoal = prefs.getDouble('profile_weight_goal') ?? 0;
    if (_weightGoal < 0) _weightGoal = 0;

    _unit = prefs.getString('pref_weight_unit') ?? "kg";
    if (_unit != "kg" && _unit != "lbs") _unit = "kg";

    _restTimer = prefs.getInt('pref_rest_timer') ?? 60;
    _restTimer = _restTimer.clamp(15, 300);

    _notifications = prefs.getBool('pref_notifications') ?? true;

    notifyListeners();
  }


  Future<void> saveName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _name = value;
    notifyListeners();
    await prefs.setString('profile_name', value);
  }

  Future<void> saveAge(int value) async {
    final prefs = await SharedPreferences.getInstance();
    _age = value;
    notifyListeners();
    await prefs.setInt('profile_age', value);
  }

  Future<void> saveWeightGoal(double value) async {
    final prefs = await SharedPreferences.getInstance();
    _weightGoal = value;
    notifyListeners();
    await prefs.setDouble('profile_weight_goal', value);
  }

  Future<void> saveUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _unit = value;
    notifyListeners();
    await prefs.setString('pref_weight_unit', value);
  }

  Future<void> saveRestTimer(int value) async {
    final prefs = await SharedPreferences.getInstance();
    _restTimer = value;
    notifyListeners();
    await prefs.setInt('pref_rest_timer', value);
  }

  Future<void> saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _notifications = value;
    notifyListeners();
    await prefs.setBool('pref_notifications', value);
  }

  Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('profile_name');
    await prefs.remove('profile_age');
    await prefs.remove('profile_weight_goal');

    _name = "Guest";
    _age = 0;
    _weightGoal = 0;

    notifyListeners();
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _name = "Guest";
    _age = 0;
    _weightGoal = 0;
    _unit = "kg";
    _restTimer = 60;
    _notifications = true;

    notifyListeners();
  }
}