import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() =>
      _SettingsProfileScreenState();
}

class _SettingsProfileScreenState
    extends State<SettingsProfileScreen> {

  final nameController = TextEditingController();
  final goalController = TextEditingController();
  String selectedUnit = "kg";

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    nameController.text = profile.name;
    goalController.text = profile.weightGoal.toString();
    selectedUnit = profile.unit;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight Goal",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedUnit,
              items: ["kg", "lbs"].map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Unit",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Save Changes"),
                    content: const Text(
                        "Do you want to save your profile changes?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {

                  context.read<ProfileProvider>().updateProfile(
                    nameController.text,
                    double.tryParse(goalController.text) ?? 0,
                    selectedUnit,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Profile saved successfully")),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}