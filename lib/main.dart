import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/routine_provider.dart';
import 'screens/bmi_screen.dart';
import 'screens/add_exercise_screen.dart';
import 'screens/exercise_browse_screen.dart';
import 'screens/routine_summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoutineProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BMIScreen()),
              );
            },
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text("BMI", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Column(
        children: [

        
          Container(
            height: 180,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [

                const Positioned(
                  top: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Morning Workout",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      SizedBox(height: 10),
                      Text("Boost your energy",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Start"),
                  ),
                ),
              ],
            ),
          ),
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double budget = 0;

  @override
  void initState() {
    super.initState();
    loadBudget();
  }

  void loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble("budget") ?? 0;

    setState(() {
      budget = value < 0 ? 0 : value;
    });
  }

  void saveBudget(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("budget", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          Text("Budget: R ${budget.toStringAsFixed(2)}"),
          Slider(
            value: budget,
            min: 0,
            max: 1000,
            onChanged: (value) {
              setState(() {
                budget = value;
              });
            },
            onChangeEnd: (value) {
              saveBudget(value);
            },
          ),
        ],
      ),
    );
  }
}
          
          Expanded(
            child: provider.routine.isEmpty
                ? const Center(child: Text("No exercises added"))
                : ListView.builder(
              itemCount: provider.routine.length,
              itemBuilder: (_, i) {
                final e = provider.routine[i];

                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(
                      "${e.sets} x ${e.reps} x ${e.weight}kg"),
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

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: "browse",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ExerciseBrowseScreen()),
              );
            },
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "summary",
            backgroundColor: Colors.green,
            child: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RoutineSummaryScreen()),
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
                    builder: (_) => const AddExerciseScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
