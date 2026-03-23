import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {

    final totalVolume = sets * reps * weight;

    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Muscle Group: $muscleGroup"),
            const SizedBox(height: 10),

            Text("Sets: $sets"),
            Text("Reps: $reps"),
            Text("Weight: $weight kg"),

            const SizedBox(height: 20),

            Text(
              "Total Volume: $totalVolume",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}