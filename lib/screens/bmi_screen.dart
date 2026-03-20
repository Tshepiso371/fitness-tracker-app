import 'package:flutter/material.dart';
import '../widgets/input_card.dart';
import '../widgets/result_box.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {

  double height = 0;
  double weight = 0;
  double bmi = 0;

  void calculateBMI() {
    if (height > 0 && weight > 0) {
      setState(() {
        bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            InputCard(
              title: "Height (cm)",
              onChanged: (value) {
                height = double.tryParse(value) ?? 0;
              },
            ),

            SizedBox(height: 10),

            InputCard(
              title: "Weight (kg)",
              onChanged: (value) {
                weight = double.tryParse(value) ?? 0;
              },
            ),

            SizedBox(height: 20),
            InkWell(
              onTap: calculateBMI,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Calculate BMI",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            ResultBox(bmi: bmi),

          ],
        ),
      ),
    );
  }
}