import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/location_service.dart';
import '../data/notification_service.dart';

enum WorkoutPhase { idle, selecting, active, finished }
enum WorkoutActivityType { walking, running, cycling }

class WorkoutTrackingProvider extends ChangeNotifier {
  final LocationService _locationService;
  final NotificationService _notificationService = NotificationService();

  WorkoutTrackingProvider(this._locationService);

  WorkoutPhase _phase = WorkoutPhase.idle;
  WorkoutActivityType _selectedActivity = WorkoutActivityType.running;

  Position? _startPosition;
  Position? _endPosition;
  Position? _currentPosition;

  double _distanceMeters = 0;
  DateTime? _startTime;
  int _elapsedSeconds = 0;

  String? _errorMessage;
  bool _isLoadingLocation = false;

  Timer? _timer;
  Timer? _pollingTimer;
  List<Position> _routePoints = [];

  // GETTERS
  WorkoutPhase get phase => _phase;
  WorkoutActivityType get selectedActivity => _selectedActivity;
  Position? get current => _currentPosition;
  Position? get start => _startPosition;
  Position? get end => _endPosition;
  bool get isLoading => _isLoadingLocation;
  String? get error => _errorMessage;
  List<Position> get routePoints => _routePoints;

  bool get canFinish => _phase == WorkoutPhase.active;

  String get formattedTime {
    final h = (_elapsedSeconds ~/ 3600);
    final m = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    if (h > 0) return "$h:$m:$s";
    return "$m:$s";
  }

  String get formattedDistance {
    if (_distanceMeters < 1000) {
      return "${_distanceMeters.toStringAsFixed(0)} m";
    } else {
      return "${(_distanceMeters / 1000).toStringAsFixed(1)} km";
    }
  }

  String get formattedPace {
    if (_distanceMeters == 0 || _elapsedSeconds == 0) return "--";
    double distanceKm = _distanceMeters / 1000;
    double totalMinutes = _elapsedSeconds / 60;
    double paceDecimal = totalMinutes / distanceKm;
    int paceMin = paceDecimal.floor();
    int paceSec = ((paceDecimal - paceMin) * 60).round();
    return "$paceMin:${paceSec.toString().padLeft(2, '0')} min/km";
  }

  String get routeRecommendation {
    switch (_selectedActivity) {
      case WorkoutActivityType.walking:
        return "Nature trails and parks are best for a steady walk.";
      case WorkoutActivityType.running:
        return "Paved paths with low traffic are ideal for maintaining pace.";
      case WorkoutActivityType.cycling:
        return "Dedicated bike lanes or wide shoulders are safest and fastest.";
    }
  }

  void setPhase(WorkoutPhase p) {
    _phase = p;
    notifyListeners();
  }

  void setActivity(WorkoutActivityType type) {
    _selectedActivity = type;
    notifyListeners();
  }

  Future<void> startWorkout() async {
    _isLoadingLocation = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pos = await _locationService.getCurrentPosition();
      _startPosition = pos;
      _currentPosition = pos;
      _startTime = DateTime.now();
      _routePoints = [pos];
      _phase = WorkoutPhase.active;

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedSeconds++;
        notifyListeners();
      });

      _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
        try {
          final p = await _locationService.getCurrentPosition();
          _routePoints.add(p);
          _currentPosition = p;
          notifyListeners();
        } catch (e) {}
      });
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _phase = WorkoutPhase.idle;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> finishWorkout() async {
    _isLoadingLocation = true;
    notifyListeners();
    _timer?.cancel();
    _pollingTimer?.cancel();

    try {
      final pos = await _locationService.getCurrentPosition();
      _endPosition = pos;
      _routePoints.add(pos);

      double totalDist = 0;
      for (int i = 0; i < _routePoints.length - 1; i++) {
        totalDist += _locationService.calculateDistance(
          _routePoints[i].latitude,
          _routePoints[i].longitude,
          _routePoints[i+1].latitude,
          _routePoints[i+1].longitude,
        );
      }
      _distanceMeters = totalDist;
      _phase = WorkoutPhase.finished;

      // TRIGGER NOTIFICATION (Requirement 9)
      await _notificationService.showWorkoutCompleteAlert(
        workoutName: _selectedActivity.name,
        distanceKm: _distanceMeters / 1000,
        time: formattedTime,
        pace: formattedPace,
      );

    } catch (e) {
      _errorMessage = e.toString();
      _phase = WorkoutPhase.finished;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void resetWorkout() {
    _phase = WorkoutPhase.idle;
    _elapsedSeconds = 0;
    _distanceMeters = 0;
    _startPosition = null;
    _endPosition = null;
    _currentPosition = null;
    _routePoints = [];
    _errorMessage = null;
    _timer?.cancel();
    _pollingTimer?.cancel();
    notifyListeners();
  }
}
