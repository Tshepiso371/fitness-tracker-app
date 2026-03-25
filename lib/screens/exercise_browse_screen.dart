import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/routine_provider.dart';

class ExerciseBrowseScreen extends StatelessWidget {
  const ExerciseBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();

    final exercises = [
      Exercise(
        id: "1",
        name: "Bench Press",
        muscleGroup: "Chest",
        sets: 3,
        reps: 10,
        weight: 60,
      ),
      Exercise(
        id: "2",
        name: "Squats",
        muscleGroup: "Legs",
        sets: 4,
        reps: 8,
        weight: 80,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Browse Exercises")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, i) {
          final e = exercises[i];
          final added = provider.isInRoutine(e.id);

          return ListTile(
            title: Text(e.name),
            subtitle: Text(e.muscleGroup),
            trailing: IconButton(
              icon: Icon(added ? Icons.check : Icons.add),
              onPressed: () {
                context.read<RoutineProvider>().addExercise(e);
              },
            ),
          );
        },
      ),
    );
  }
}