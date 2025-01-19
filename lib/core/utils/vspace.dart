import 'package:flutter/material.dart';

class Vspace extends StatelessWidget {
  const Vspace(this.height, {super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
