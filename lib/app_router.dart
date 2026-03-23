import 'package:flutter/material.dart';
import 'exercise_list_screen.dart';
import 'exercise_detail_screen.dart';


class ExerciseListArgs {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListArgs({
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });
}

class ExerciseDetailArgs {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailArgs({
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}


enum AppRoute<T> {
  home<void>(),
  exerciseList<ExerciseListArgs>(),
  exerciseDetail<ExerciseDetailArgs>();

  Route route(T args) {
    switch (this) {

      case AppRoute.home:
        return MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (_) => const SizedBox(),
        );

      case AppRoute.exerciseList:
        final data = args as ExerciseListArgs;
        return MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (_) => ExerciseListScreen(
            categoryName: data.categoryName,
            themeColor: data.themeColor,
            iconData: data.iconData,
          ),
        );

      case AppRoute.exerciseDetail:
        final data = args as ExerciseDetailArgs;
        return MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (_) => ExerciseDetailScreen(
            exerciseName: data.exerciseName,
            muscleGroup: data.muscleGroup,
            sets: data.sets,
            reps: data.reps,
            weight: data.weight,
          ),
        );
    }
  }
}


extension AppNavigator on NavigatorState {

  Future<void> pushRoute(AppRoute<void> route) {
    return push(route.route(null));
  }

  Future<void> pushRouteWithArgs<T>(AppRoute<T> route, T args) {
    return push(route.route(args));
  }
}