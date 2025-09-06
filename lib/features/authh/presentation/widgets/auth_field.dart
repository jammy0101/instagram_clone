import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obSecure = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obSecure;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obSecure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(23),
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
    );
  }
}
