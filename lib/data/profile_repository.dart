import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  static const String _key = 'user_profile';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_key, jsonString);
  }

  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return UserProfile.defaults();

      final json = jsonDecode(jsonString);
      return UserProfile.fromJson(json);
    } catch (e) {
      return UserProfile.defaults();
    }
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}