import 'package:flutter/material.dart';

class CustomIconButon extends StatelessWidget {
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? overlyColor;
  final Widget prefixIcon;
  final Widget label;
  const CustomIconButon(
      {super.key,
      required this.prefixIcon,
      required this.label,
      this.foregroundColor,
      this.backgroundColor,
      this.overlyColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
        foregroundColor: MaterialStatePropertyAll(foregroundColor),
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        overlayColor: MaterialStatePropertyAll(overlyColor),
        minimumSize: const MaterialStatePropertyAll(
          Size(double.infinity, 50),
        ),
      ),
      label: Center(child: label),
      icon: prefixIcon,
    );
  }
}
