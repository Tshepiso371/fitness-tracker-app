import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final goalController = TextEditingController();

  double sliderValue = 60;

  @override
  void didChangeDependencies() {
    final p = context.read<ProfileProvider>();

    nameController.text = p.name;
    ageController.text = p.age == 0 ? "" : p.age.toString();
    goalController.text = p.weightGoal == 0 ? "" : p.weightGoal.toString();

    sliderValue = p.restTimer.toDouble();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            const Text("Profile", style: TextStyle(fontSize: 20)),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
              onSubmitted: (v) => p.saveName(v),
            ),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
              onSubmitted: (v) {
                final age = int.tryParse(v);
                if (age != null && age > 0 && age <= 120) {
                  p.saveAge(age);
                }
              },
            ),

            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight Goal",
                suffixText: p.unit,
              ),
              onSubmitted: (v) {
                final goal = double.tryParse(v);
                if (goal != null && goal > 0) {
                  p.saveWeightGoal(goal);
                }
              },
            ),

            const SizedBox(height: 20),

            const Text("Preferences", style: TextStyle(fontSize: 20)),

            Row(
              children: [
                const Text("kg"),
                Radio(
                  value: "kg",
                  groupValue: p.unit,
                  onChanged: (v) => p.saveUnit(v!),
                ),
                const Text("lbs"),
                Radio(
                  value: "lbs",
                  groupValue: p.unit,
                  onChanged: (v) => p.saveUnit(v!),
                ),
              ],
            ),

            Slider(
              min: 15,
              max: 300,
              divisions: 19,
              value: sliderValue,
              label: "${sliderValue.toInt()} sec",
              onChanged: (v) {
                setState(() => sliderValue = v);
              },
              onChangeEnd: (v) {
                p.saveRestTimer(v.toInt());
              },
            ),

            SwitchListTile(
              title: const Text("Notifications"),
              value: p.notifications,
              onChanged: (v) => p.saveNotifications(v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => p.resetProfile(),
              child: const Text("Reset Profile"),
            ),

            ElevatedButton(
              onPressed: () => p.resetAll(),
              child: const Text("Reset Everything"),
            ),
          ],
        ),
      ),
    );
  }
}