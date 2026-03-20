import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final String title;
  final Function(String) onChanged;

  const InputCard({
    super.key,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }
}