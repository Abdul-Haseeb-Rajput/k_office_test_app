import 'package:flutter/material.dart';

class CustomBgShadowContainer extends StatelessWidget {
  final BoxShape? shape;
  final double? height;
  final double? width;
  final Widget? child;
  final DecorationImage? backgroundImage;
  const CustomBgShadowContainer(
      {super.key,
      this.shape,
      this.height,
      this.width,
      this.backgroundImage,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: backgroundImage,
        color: const Color.fromARGB(255, 17, 17, 17),
        borderRadius: shape == BoxShape.rectangle
            ? const BorderRadius.all(Radius.circular(12.0))
            : null,
        shape: shape!,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            spreadRadius: .4,
            offset: Offset(4.0, 4.0),
          ),
          BoxShadow(
              color: Color.fromARGB(255, 24, 24, 24),
              blurRadius: 8,
              spreadRadius: .4,
              offset: Offset(-4.0, -4.0)),
        ],
      ),
      child: child,
    );
  }
}
