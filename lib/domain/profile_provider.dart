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
  double get weightGoal => _profile.weightGoal;
  String get unit => _profile.weightUnit;

  Future<void> _init() async {
    _profile = await _repository.loadProfile();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(name: name);
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
}