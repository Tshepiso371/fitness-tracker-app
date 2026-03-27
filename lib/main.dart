

import 'providers/routine_provider.dart';
import 'providers/profile_provider.dart';

import 'screens/bmi_screen.dart';
import 'screens/add_exercise_screen.dart';
import 'screens/exercise_browse_screen.dart';
import 'screens/routine_summary_screen.dart';
import 'screens/settings_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
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
    final profile = context.watch<ProfileProvider>(); // :white_check_mark: NEW

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        backgroundColor: Colors.pinkAccent,
        actions: [

          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsProfileScreen(),
                ),
              );
            },
          ),


          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BMIScreen()),
              );
            },
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: const Text("BMI Calculator", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              profile.name == "Guest" || profile.name.isEmpty
                  ? "Welcome!"
                  : "Welcome back, ${profile.name}!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          if (profile.weightGoal > 0)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Goal: ${profile.weightGoal} ${profile.unit}",
                style: const TextStyle(color: Colors.grey),
              ),
            ),


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