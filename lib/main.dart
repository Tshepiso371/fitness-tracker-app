import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/profile_repository.dart';
import 'data/routine_repository.dart';
import 'data/exercise_api_repository.dart';
import 'data/location_service.dart';

import 'domain/profile_provider.dart';
import 'domain/routine_provider.dart';
import 'domain/exercise_search_provider.dart';
import 'domain/workout_tracking_provider.dart';

import 'presentation/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/notification_service.dart';

import 'data/auth_service.dart';
import 'domain/auth_provider.dart';
import 'presentation/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(RoutineRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              ExerciseSearchProvider(ExerciseApiRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              WorkoutTrackingProvider(LocationService()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(AuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}
