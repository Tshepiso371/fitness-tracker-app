import 'package:flutter/material.dart';
import 'screens/bmi_screen.dart';
import 'screens/exercise_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BMIScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // :fire: Banner
          Container(
            height: 180,
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const Positioned(
                  top: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Morning Workout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Boost your energy for the day",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Workout Started!"),
                        ),
                      );
                    },
                    child: const Text("Start"),
                  ),
                ),

              ],
            ),
          ),

          // :fire: Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {

                int crossAxisCount = 2;

                if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                }

                if (constraints.maxWidth > 900) {
                  crossAxisCount = 4;
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  padding: const EdgeInsets.all(10),
                  children: const [

                    WorkoutTile(title: "Cardio", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Strength", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Flexibility", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "HIIT", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Yoga", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Pilates", color: Colors.lightBlueAccent),

                  ],
                );
              },
            ),
          ),

        ],
      ),

      // :fire: ADD EXERCISE BUTTON (IMPORTANT)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExerciseScreen(),
            ),
          );

          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Exercise Added Successfully!"),
              ),
            );
          }
        },
      ),
    );
  }
}

class WorkoutTile extends StatefulWidget {
  final String title;
  final Color color;

  const WorkoutTile({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  State<WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [

          Center(
            child: Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),

          Positioned(
            right: 5,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),

        ],
      ),
    );
  }
}