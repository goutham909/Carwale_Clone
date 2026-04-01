import 'package:flutter/material.dart';

import '../core/constants.dart';

/// CarWale-style wordmark + grille mark (matches reference app bar).
class CwLogoMark extends StatelessWidget {
  const CwLogoMark({super.key, this.fontSize = 18});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 18,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 3, left: 3, right: 3),
              height: 2,
              decoration: BoxDecoration(
                color: kCwTeal,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
        SizedBox(width: fontSize * 0.35),
        Text(
          'carwale',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
