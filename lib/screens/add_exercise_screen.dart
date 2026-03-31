import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../domain/routine_provider.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();
  final weightController = TextEditingController();

  String? selectedMuscle;

  double totalVolume = 0;

  @override
  void initState() {
    super.initState();

    setsController.addListener(updateVolume);
    repsController.addListener(updateVolume);
    weightController.addListener(updateVolume);
  }

  void updateVolume() {
    final sets = int.tryParse(setsController.text);
    final reps = int.tryParse(repsController.text);
    final weight = double.tryParse(weightController.text);

    if (sets != null && reps != null && weight != null) {
      setState(() {
        totalVolume = sets * reps * weight;
      });
    } else {
      setState(() {
        totalVolume = 0;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Exercise"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [


                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Exercise Name",
                    hintText: "e.g. Bench Press",
                    prefixIcon: Icon(Icons.fitness_center),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Exercise name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Sets",
                    hintText: "e.g. 3",
                    prefixIcon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of sets is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Reps",
                    hintText: "e.g. 10",
                    prefixIcon: Icon(Icons.repeat),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of reps is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),


                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Weight",
                    hintText: "e.g. 20",
                    prefixIcon: Icon(Icons.fitness_center),
                    suffixText: "kg",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Weight is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: selectedMuscle,
                  decoration: const InputDecoration(
                    hintText: "Select Muscle Group...",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Chest",
                    "Back",
                    "Legs",
                    "Arms",
                    "Shoulders",
                    "Core"
                  ].map((muscle) {
                    return DropdownMenuItem(
                      value: muscle,
                      child: Text(muscle),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMuscle = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a muscle group";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),


                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    totalVolume == 0
                        ? "Total Volume: --"
                        : "Total Volume: ${totalVolume.toStringAsFixed(0)} kg",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      
                      final exercise = Exercise(
                        id: DateTime.now().toString(),
                        name: nameController.text,
                        sets: int.parse(setsController.text),
                        reps: int.parse(repsController.text),
                        weight: double.parse(weightController.text),
                        muscleGroup: selectedMuscle!,
                      );

                      context.read<RoutineProvider>().addExercise(exercise);
                      
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Exercise"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
