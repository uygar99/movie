import 'package:flutter/material.dart';
import 'dart:math' as math;

class DrumClipper extends CustomClipper<Path> {
  final double globalAngle; 
  final double radius;
  final double cardWidth;

  DrumClipper({
    required this.globalAngle,
    required this.radius,
    required this.cardWidth,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double sweep = cardWidth / radius;
    final int segments = 20;
    const double viewLimitCos = 0.60; 

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double theta = globalAngle + (t - 0.5) * sweep;
      final double dy = (math.cos(theta) - viewLimitCos).clamp(0, 1) * radius * 0.22;
      if (i == 0) {
        path.moveTo(t * size.width, dy);
      } else {
        path.lineTo(t * size.width, dy);
      }
    }

    for (int i = segments; i >= 0; i--) {
      final double t = i / segments;
      final double theta = globalAngle + (t - 0.5) * sweep;
      final double dy = (math.cos(theta) - viewLimitCos).clamp(0, 1) * radius * 0.22;
      path.lineTo(t * size.width, size.height - dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DrumClipper oldClipper) => 
      oldClipper.globalAngle != globalAngle;
}
