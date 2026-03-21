import 'package:flutter/material.dart';

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
        title: Text("Add Exercise"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [


                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Exercise Name",
                    hintText: "e.g. Bench Press",
                    prefixIcon: Icon(Icons.fitness_center),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Exercise name is required';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    if (value.length > 50) {
                      return 'Name cannot exceed 50 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Sets",
                    hintText: "e.g. 3",
                    prefixIcon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of sets is required';
                    }
                    final sets = int.tryParse(value);
                    if (sets == null) {
                      return 'Sets must be a whole number';
                    }
                    if (sets <= 0) {
                      return 'Sets must be greater than zero';
                    }
                    if (sets > 20) {
                      return 'Sets cannot exceed 20';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Reps",
                    hintText: "e.g. 10",
                    prefixIcon: Icon(Icons.repeat),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of reps is required';
                    }
                    final reps = int.tryParse(value);
                    if (reps == null) {
                      return 'Reps must be a whole number';
                    }
                    if (reps <= 0) {
                      return 'Reps must be greater than zero';
                    }
                    if (reps > 100) {
                      return 'Reps cannot exceed 100';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                // Weight
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                    final weight = double.tryParse(value);
                    if (weight == null) {
                      return 'Weight must be a valid number';
                    }
                    if (weight < 0) {
                      return 'Weight cannot be negative';
                    }
                    if (weight > 500) {
                      return 'Weight cannot exceed 500kg';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: selectedMuscle,
                  decoration: InputDecoration(
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

                SizedBox(height: 20),


                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    totalVolume == 0
                        ? "Total Volume: --"
                        : "Total Volume: ${totalVolume.toStringAsFixed(0)} kg",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      final exerciseData = {
                        'name': nameController.text,
                        'sets': setsController.text,
                        'reps': repsController.text,
                        'weight': weightController.text,
                        'muscle': selectedMuscle,
                      };

                      Navigator.pop(context, exerciseData);
                    }
                  },
                  child: Text("Save Exercise"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}