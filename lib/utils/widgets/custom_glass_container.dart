// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomGlassContainer extends StatelessWidget {
  final TextEditingController? emailController;
  final double? boxHeight;
  final Widget? column;
  const CustomGlassContainer({
    Key? key,
    this.emailController,
    required this.boxHeight,
    this.column,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(18))),
        height: 500,
        child: Stack(
          children: [
            // blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                height: boxHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  // gradient effect
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(142, 72, 72, 72),
                      Color.fromARGB(236, 37, 37, 37),
                    ],
                  ),
                ),
                child: Center(
                  child: column,
                ),
              ),
            ),
            // children
          ],
        ),
      ),
    );
  }
}
