import 'package:flutter/foundation.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  UserProfile _profile = UserProfile.defaults();

  ProfileProvider(this._repository) {
    _init();
  }

  UserProfile get profile => _profile;

  String get name => _profile.name;
  int get age => _profile.age;
  double get weightGoal => _profile.weightGoal;
  String get unit => _profile.weightUnit;
  int get restTimer => _profile.restTimerSeconds;
  bool get notifications => _profile.notificationsEnabled;

  Future<void> _init() async {
    _profile = await _repository.loadProfile();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(name: name);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateAge(int age) async {
    _profile = _profile.copyWith(age: age);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateGoal(double goal) async {
    _profile = _profile.copyWith(weightGoal: goal);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateUnit(String unit) async {
    _profile = _profile.copyWith(weightUnit: unit);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateRestTimer(int seconds) async {
    _profile = _profile.copyWith(restTimerSeconds: seconds);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateNotifications(bool enabled) async {
    _profile = _profile.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> resetProfile() async {
    _profile = UserProfile.defaults();
    notifyListeners();
    await _repository.saveProfile(_profile);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_log.dart';

class WeatherLogProvider extends ChangeNotifier {
  List<WeatherLog> _logs = [];

  List<WeatherLog> get logs => _logs;

  Future<void> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('logs');

    if (data != null) {
      List decoded = jsonDecode(data);
      _logs = decoded.map((e) => WeatherLog.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addLog(WeatherLog log) async {
    _logs.add(log);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'logs', jsonEncode(_logs.map((e) => e.toJson()).toList()));
  }
}
