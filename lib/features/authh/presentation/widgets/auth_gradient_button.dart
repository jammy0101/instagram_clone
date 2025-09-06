import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPallete.gradient1, AppPallete.gradient1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor,
          ),
        ),
      ),
    );
  }
}
