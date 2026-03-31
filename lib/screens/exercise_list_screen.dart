import 'package:flutter/material.dart';
import "../app_router.dart";

class ExerciseListScreen extends StatelessWidget {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListScreen({
    super.key,
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {

    final brightness =
    ThemeData.estimateBrightnessForColor(themeColor);

    final foregroundColor =
    brightness == Brightness.dark ? Colors.white : Colors.black;

    final exercises = [
      "Running",
      "Cycling",
      "Jump Rope",
      "Rowing"
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("$categoryName Exercises"),
        backgroundColor: themeColor,
        foregroundColor: foregroundColor,
        leading: Icon(iconData),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {

          final name = exercises[index];

          return ListTile(
            title: Text(name),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pushRouteWithArgs(
                AppRoute.exerciseDetail,
                ExerciseDetailArgs(
                  exerciseName: name,
                  muscleGroup: "General",
                  sets: 3,
                  reps: 10,
                  weight: 20,
                ),
              );
            },
          );
        },
      ),
    );
  }
}