import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routine_provider.dart';

class RoutineSummaryScreen extends StatelessWidget {
  const RoutineSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Routine")),
      body: provider.routine.isEmpty
          ? const Center(child: Text("No exercises"))
          : Column(
        children: [

          Text("Total Exercises: ${provider.exerciseCount}"),
          Text("Total Sets: ${provider.totalSets}"),
          Text("Total Volume: ${provider.totalVolume} kg"),

          Expanded(
            child: ListView.builder(
              itemCount: provider.routine.length,
              itemBuilder: (_, i) {
                final e = provider.routine[i];

                return ListTile(
                  title: Text(e.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<RoutineProvider>()
                          .removeExercise(e.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}