import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/routine_provider.dart';

class RoutineSummaryScreen extends StatelessWidget {
  const RoutineSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Routine Summary"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn("Exercises", provider.routine.length.toString()),
                _buildStatColumn("Total Sets", _calculateTotalSets(provider).toString()),
              ],
            ),
          ),
          Expanded(
            child: provider.routine.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.routine.length,
                    itemBuilder: (_, i) {
                      final e = provider.routine[i];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${e.sets} sets • ${e.reps} reps"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => context.read<RoutineProvider>().removeExercise(e.id),
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

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("No data available", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  int _calculateTotalSets(RoutineProvider provider) {
    return provider.routine.fold(0, (sum, e) => sum + e.sets);
  }
}
