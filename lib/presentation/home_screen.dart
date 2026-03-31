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

import 'outdoor_workout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Fitness Tracker", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
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
            icon: const Icon(Icons.settings, color: Colors.white),
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
            label: const Text("BMI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${profileProvider.name}!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                if (profileProvider.weightGoal > 0)
                  Text(
                    "Target: ${profileProvider.weightGoal} ${profileProvider.unit}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pinkAccent.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Main Card
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
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 30,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Daily Routine",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Keep up the great work!",
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text("Start Workout", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // Quick Actions Row (Modern replacement for extra FABs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickActionItem(
                  icon: Icons.directions_run,
                  label: "Outdoor",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OutdoorWorkoutScreen(),
                      ),
                    );
                  },
                ),
                _QuickActionItem(
                  icon: Icons.list,
                  label: "Browse",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExerciseBrowseScreen(),
                      ),
                    );
                  },
                ),
                _QuickActionItem(
                  icon: Icons.analytics,
                  label: "Summary",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoutineSummaryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
            child: Text(
              "Today's Exercises",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),

          Expanded(
            child: provider.routine.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No exercises added yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: provider.routine.length,
                    itemBuilder: (context, i) {
                      final e = provider.routine[i];

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.fitness_center, color: Colors.pinkAccent),
                          ),
                          title: Text(e.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text(
                              "${e.sets} sets • ${e.reps} reps • ${e.weight}${profileProvider.unit}",
                              style: TextStyle(color: Colors.grey[600])),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                      child: const Text("Remove", style: TextStyle(color: Colors.red)),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Exercise", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExerciseScreen(),
            ),
          );
        },
      ),
    );
  }
}

// Helper Widget for Modern Quick Actions
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
