import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String label;
  final bool isPass;
  const LoginField({
    super.key, 
    required this.label, 
    this.isPass = false
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          color: Color.fromRGBO(36, 36, 36, 0.4),
          fontSize: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Color.fromRGBO(255, 240, 240, 0.63),
        filled: true,
      ),
      obscureText: isPass,
    );
  }
}
