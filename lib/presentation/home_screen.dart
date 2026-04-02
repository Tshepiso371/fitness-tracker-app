import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/routine_provider.dart';
import '../domain/profile_provider.dart';
import '../domain/auth_provider.dart';

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
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Fitness Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
        actions: [

          //  SEARCH
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

          //  SETTINGS
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

          //  BMI
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
            label: const Text(
              "BMI",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          //  LOGOUT
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Sign Out"),
                    content: const Text(
                        "Are you sure you want to sign out?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: const Text("Sign Out"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await context.read<AuthProvider>().logout();
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text("Sign Out"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //  PERSONALIZED GREETING
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${auth.userName ?? (auth.userEmail != null ? auth.userEmail!.split('@')[0] : 'Guest')}!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                
                if (auth.lastSignIn != null)
                  Text(
                    "Last signed in: ${auth.lastSignIn!.toLocal()}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                if (profileProvider.weightGoal > 0)
                  Text(
                    "Target: ${profileProvider.weightGoal} ${profileProvider.unit}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pinkAccent.shade700,
                    ),
                  ),
              ],
            ),
          ),

          //  MAIN CARD
          Container(
            height: 160,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pinkAccent, Colors.orangeAccent],
              ),
              borderRadius: BorderRadius.circular(24),
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
                          style:
                          TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Start Workout"),
                  ),
                ),
              ],
            ),
          ),

          //  QUICK ACTIONS
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [

                //  OUTDOOR WORKOUT
                _QuickActionItem(
                  icon: Icons.directions_run,
                  label: "Outdoor",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const OutdoorWorkoutScreen(),
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
                        builder: (_) =>
                        const ExerciseBrowseScreen(),
                      ),
                    );
                  },
                ),

                // SUMMARY
                _QuickActionItem(
                  icon: Icons.analytics,
                  label: "Summary",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const RoutineSummaryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding:
            EdgeInsets.fromLTRB(20, 10, 16, 10),
            child: Text(
              "Today's Exercises",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ),

          // EXERCISE LIST
          Expanded(
            child: provider.routine.isEmpty
                ? const Center(
              child: Text("No exercises added yet"),
            )
                : ListView.builder(
              itemCount: provider.routine.length,
              itemBuilder: (context, i) {
                final e = provider.routine[i];

                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(
                      "${e.sets} x ${e.reps} x ${e.weight}${profileProvider.unit}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm =
                      await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                              "Remove Exercise"),
                          content: Text(
                              "Remove ${e.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(
                                      context, false),
                              child:
                              const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(
                                      context, true),
                              child:
                              const Text("Remove"),
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
                );
              },
            ),
          ),
        ],
      ),

      //  ADD BUTTON
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Exercise",
            style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddExerciseScreen(),
            ),
          );
        },
      ),
    );
  }
}


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
          Text(label),
        ],
      ),
    );
  }
}
