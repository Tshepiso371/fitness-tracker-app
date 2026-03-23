import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final double bmi;


  const ResultBox({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    String message = "";
    Color color = Colors.grey;

    if (bmi > 0 && bmi < 18.5) {
      color = Colors.blue;
      message = "underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      color = Colors.green;
      message = "Normal";
    } else if (bmi >= 25 && bmi < 30) {
      color = Colors.orange;
      message = "Overweight";
    } else if (bmi >= 30) {
      color = Colors.red;
      message = "Obese";
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        bmi == 0 ? "Enter values to calculate BMI"
            : "Your BMI: ${bmi.toStringAsFixed(2)}\n$message",
        style: TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}