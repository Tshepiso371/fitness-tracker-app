import 'package:flutter/material.dart';

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

  Future<String> getWorkoutTip() async {
    await Future.delayed(Duration(seconds: 3));
    return "Remember to stay hydrated during workouts!";
  }

  @override
  Widget build(BuildContext context) {
    String? username;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FutureBuilder(
              future: getWorkoutTip(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Text(
                  snapshot.data ?? "Welcome to Fitness Tracker",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                );
              },
            ),

            SizedBox(height: 30),

            // future feature
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Healthy Meal Suggestions Coming Soon!"),
                  ),
                );
              },
              child: Text("Healthy Meals"),
             ),

          ],
        ),
      ),
            );

  }
}