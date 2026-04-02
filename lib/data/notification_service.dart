import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(settings);
    _isInitialized = true;
  }

  // Extra Credit: Intelligent Notification Content
  Future<void> showWorkoutCompleteAlert({
    required String workoutName,
    required double distanceKm,
    required String time,
    required String pace,
  }) async {
    String title = "Workout Complete!";
    String body = "";

    // Dynamic Body based on distance
    if (distanceKm > 5) {
      body = "Amazing endurance! You covered ${distanceKm.toStringAsFixed(1)} km in $time.";
    } else if (distanceKm > 2) {
      body = "Solid run! ${distanceKm.toStringAsFixed(1)} km at $pace pace.";
    } else if (distanceKm > 0) {
      body = "Every step counts! You ran ${distanceKm.toStringAsFixed(1)} km today.";
    } else {
      body = "$workoutName complete! Keep the streak alive.";
    }

    const androidDetails = AndroidNotificationDetails(
      'workout_complete',
      'Workout Completion',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(0, title, body, details);
  }

  Future<void> showReminderNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(1, title, body, details);
  }
}
