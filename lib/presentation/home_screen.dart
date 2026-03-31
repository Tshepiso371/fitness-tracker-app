import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/routine_provider.dart';
import '../domain/profile_provider.dart';

import '../screens/bmi_screen.dart';
import '../screens/add_exercise_screen.dart';
import '../screens/exercise_browse_screen.dart';
import '../screens/routine_summary_screen.dart';
import '../screens/settings_profile_screen.dart';
import 'exercise_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExerciseSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsProfileScreen(),
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BMIScreen(),
                ),
              );
            },
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text("BMI", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${profileProvider.name}!",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (profileProvider.weightGoal > 0)
                  Text(
                    "Goal: ${profileProvider.weightGoal} ${profileProvider.unit}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pinkAccent.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: 160,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pinkAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 25,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Daily Routine",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Keep up the great work!",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Start Workout"),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 5),
            child: Text(
              "Today's Exercises",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: provider.routine.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No exercises added yet"),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: provider.routine.length,
                    itemBuilder: (context, i) {
                      final e = provider.routine[i];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: ListTile(
                          title: Text(e.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "${e.sets} sets • ${e.reps} reps • ${e.weight}${profileProvider.unit}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Remove Exercise"),
                                  content: Text(
                                      "Remove ${e.name} from your routine?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Remove"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                context
                                    .read<RoutineProvider>()
                                    .removeExercise(e.id);
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: "browse",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExerciseBrowseScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: "summary",
            backgroundColor: Colors.green,
            child: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoutineSummaryScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExerciseScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
