import 'package:flutter/material.dart';

/// A shared triple-wavy-bottom header used across ALL screens.
class WavyHeader extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final double extraBottomPadding;

  const WavyHeader({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF8B7FE8), Color(0xFFB8A9FF)],
    this.extraBottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TripleWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Extra bottom padding so content isn't hidden behind the wave
        padding: EdgeInsets.only(bottom: 40 + extraBottomPadding),
        child: child,
      ),
    );
  }
}

class _TripleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.lineTo(0, h - 48);
    // Wave 1 (left)
    path.quadraticBezierTo(w * 0.15, h - 8,  w * 0.32, h - 38);
    // Wave 2 (middle)
    path.quadraticBezierTo(w * 0.50, h - 72, w * 0.68, h - 38);
    // Wave 3 (right)
    path.quadraticBezierTo(w * 0.85, h - 8,  w,        h - 42);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
