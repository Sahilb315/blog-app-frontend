import 'package:flutter/material.dart';


class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    super.key,
    required this.controller,
    required this.suffixIcon,
  });

  final TextEditingController controller;
  final Icon suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorRadius: const Radius.circular(8),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.brown.shade300,
            width: 1.1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.brown.shade300,
            width: 1.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.brown.shade300,
            width: 1.1,
          ),
        ),
      ),
    );
  }
}