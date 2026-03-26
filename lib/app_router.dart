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

import 'package:flutter/material.dart';
import '../models/category.dart';
import 'category_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(name: "Spices", color: Colors.orange),
    Category(name: "Snacks", color: Colors.purple),
    Category(name: "Drinks", color: Colors.blue),
    Category(name: "Canned", color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuickCart"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).size.width > 600 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(category: cat),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: cat.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Center(
                child: Text(
                  cat.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
