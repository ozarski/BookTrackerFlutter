import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  const StatWidget(
      {super.key,
      required this.title,
      required this.value,
      this.fontSize = 25.0});

  final double fontSize;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: TextStyle(fontSize: fontSize)),
        Text(title),
      ],
    );
  }
}
