import 'package:flutter/material.dart';

class RoundedCornerContainer extends StatelessWidget {

  final double? height;
  final double? width;
  final Color? color;
  final BorderRadius? borderRadius;
  final Widget child;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  const RoundedCornerContainer({
    super.key, this.height, this.width, this.color, this.borderRadius, required this.child, this.borderColor, this.borderWidth, this.boxShadow, this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: Border.all(width: borderWidth ?? 0, color: borderColor ?? Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}