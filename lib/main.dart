import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/profile_repository.dart';
import 'data/routine_repository.dart';

import 'domain/profile_provider.dart';
import 'domain/routine_provider.dart';

import 'presentation/home_screen.dart';

void main() {
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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}