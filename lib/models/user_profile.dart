import 'dart:convert';

class UserProfile {
  final String name;
  final int age;
  final double weightGoal;
  final String weightUnit;
  final int restTimerSeconds;
  final bool notificationsEnabled;

  const UserProfile({
    required this.name,
    required this.age,
    required this.weightGoal,
    required this.weightUnit,
    required this.restTimerSeconds,
    required this.notificationsEnabled,
  });

  factory UserProfile.defaults() {
    return const UserProfile(
      name: "Guest",
      age: 0,
      weightGoal: 0.0,
      weightUnit: "kg",
      restTimerSeconds: 60,
      notificationsEnabled: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weightGoal': weightGoal,
      'weightUnit': weightUnit,
      'restTimerSeconds': restTimerSeconds,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? "Guest",
      age: (json['age'] is int && json['age'] >= 0 && json['age'] <= 120)
          ? json['age']
          : 0,
      weightGoal: (json['weightGoal'] is num && json['weightGoal'] >= 0)
          ? json['weightGoal'].toDouble()
          : 0.0,
      weightUnit: (json['weightUnit'] == "kg" || json['weightUnit'] == "lbs")
          ? json['weightUnit']
          : "kg",
      restTimerSeconds: (json['restTimerSeconds'] is int &&
          json['restTimerSeconds'] >= 15 &&
          json['restTimerSeconds'] <= 300)
          ? json['restTimerSeconds']
          : 60,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? weightGoal,
    String? weightUnit,
    int? restTimerSeconds,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      weightGoal: weightGoal ?? this.weightGoal,
      weightUnit: weightUnit ?? this.weightUnit,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      notificationsEnabled:
      notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

