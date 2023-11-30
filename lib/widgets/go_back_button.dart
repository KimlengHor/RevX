import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {

  const GoBackButton({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset('assets/images/arrow-left.png'),
    );
  }
}