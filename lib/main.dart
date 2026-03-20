import 'package:flutter/material.dart';
import 'screens/bmi_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      home: HomeScreen(),
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
            icon: Icon(Icons.calculate),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMIScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Container(
            height: 180,
            margin: EdgeInsets.all(10),
            child: Stack(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                Positioned(
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
                        SnackBar(
                          content: Text("Workout Started! "),
                        ),
                      );
                    },
                    child: Text("Start"),
                  ),
                ),

              ],
            ),
          ),

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
                  padding: EdgeInsets.all(10),
                  children: const [

                    WorkoutTile(title: "Cardio", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Strength", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Flexibility", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "HIIT", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Yoga", color: Colors.lightBlueAccent),
                    WorkoutTile(title: "Pilates", color: Colors.lightBlueAccent)

                  ],
                );
              },
            ),
          ),

        ],
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
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [

          Center(
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.white, fontSize: 18),
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