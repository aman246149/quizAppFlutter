import 'package:flutter/material.dart';

class Hspace extends StatelessWidget {
  const Hspace(this.width, {super.key});

  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
