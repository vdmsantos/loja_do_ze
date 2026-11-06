import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const EditText({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
