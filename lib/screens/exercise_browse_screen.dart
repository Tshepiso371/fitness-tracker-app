import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../domain/routine_provider.dart';

class ExerciseBrowseScreen extends StatelessWidget {
  const ExerciseBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();

    final exercises = [
      Exercise(id: "1", name: "Bench Press", muscleGroup: "Chest", sets: 3, reps: 10, weight: 60),
      Exercise(id: "2", name: "Incline Dumbbell Press", muscleGroup: "Chest", sets: 3, reps: 12, weight: 20),
      Exercise(id: "3", name: "Squats", muscleGroup: "Legs", sets: 4, reps: 8, weight: 80),
      Exercise(id: "4", name: "Leg Press", muscleGroup: "Legs", sets: 3, reps: 12, weight: 120),
      Exercise(id: "5", name: "Pull Ups", muscleGroup: "Back", sets: 3, reps: 8, weight: 0),
      Exercise(id: "6", name: "Deadlifts", muscleGroup: "Back", sets: 3, reps: 5, weight: 100),
      Exercise(id: "7", name: "Overhead Press", muscleGroup: "Shoulders", sets: 3, reps: 10, weight: 40),
      Exercise(id: "8", name: "Lateral Raises", muscleGroup: "Shoulders", sets: 3, reps: 15, weight: 10),
      Exercise(id: "9", name: "Bicep Curls", muscleGroup: "Arms", sets: 3, reps: 12, weight: 15),
      Exercise(id: "10", name: "Tricep Pushdowns", muscleGroup: "Arms", sets: 3, reps: 15, weight: 25),
      Exercise(id: "11", name: "Plank", muscleGroup: "Core", sets: 3, reps: 60, weight: 0),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Exercises"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              "Choose exercises to add to your daily routine",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (_, i) {
                final e = exercises[i];
                final added = provider.routine.any((item) => item.id == e.id);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: _getMuscleColor(e.muscleGroup).withOpacity(0.2),
                      child: Icon(Icons.fitness_center, color: _getMuscleColor(e.muscleGroup)),
                    ),
                    title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(e.muscleGroup, style: TextStyle(color: Colors.grey.shade600)),
                    trailing: IconButton(
                      icon: Icon(
                        added ? Icons.check_circle : Icons.add_circle_outline,
                        color: added ? Colors.green : Colors.pinkAccent,
                        size: 30,
                      ),
                      onPressed: () {
                        if (!added) {
                          context.read<RoutineProvider>().addExercise(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${e.name} added to routine"), duration: const Duration(seconds: 1)),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest': return Colors.red;
      case 'legs': return Colors.orange;
      case 'back': return Colors.green;
      case 'shoulders': return Colors.blue;
      case 'arms': return Colors.purple;
      case 'core': return Colors.teal;
      default: return Colors.grey;
    }
  }
}
