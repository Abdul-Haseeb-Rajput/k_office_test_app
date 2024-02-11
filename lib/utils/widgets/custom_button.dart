import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? overlyColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.foregroundColor,
    this.backgroundColor,
    this.overlyColor,
    this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
        foregroundColor: MaterialStatePropertyAll(foregroundColor),
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        overlayColor: MaterialStatePropertyAll(overlyColor),
        minimumSize: const MaterialStatePropertyAll(
          Size(double.infinity, 50),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
