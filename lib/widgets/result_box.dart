import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final double bmi;

  const ResultBox({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {

    Color color = Colors.grey;

    if (bmi > 0 && bmi < 18.5) {
      color = Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      color = Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      color = Colors.orange;
    } else if (bmi >= 30) {
      color = Colors.red;
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        bmi == 0 ? "Enter values to calculate BMI"
            : "Your BMI: ${bmi.toStringAsFixed(2)}",
        style: TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}