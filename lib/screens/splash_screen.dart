import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:maintainiq/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Dot + ripple state
  bool _isDotCenter = false;
  bool _isScaleCircle = false;

  // Phase 2
  bool _showMainUI = false;
  bool _hideWhite = false;

  // Cards animation
  late AnimationController _cardsCtrl;
  late List<Animation<double>> _cardAnims;

  @override
  void initState() {
    super.initState();

    _cardsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardAnims = List.generate(
      3,
      (i) => CurvedAnimation(
        parent: _cardsCtrl,
        curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeOut),
      ),
    );

    // Step 1 — dot slides from left into logo center (1500ms pause so logo is seen)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isDotCenter = true);
    });

    // Step 2 — dot ripples out to fill screen (700ms after dot arrives)
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      setState(() => _isScaleCircle = true);
    });

    // Step 3 — show gradient + main UI (while ripple is mid-expand)
    Future.delayed(const Duration(milliseconds: 2700), () {
      if (!mounted) return;
      setState(() => _showMainUI = true);
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) _cardsCtrl.forward();
      });
    });

    // Step 4 — hide white overlay completely
    Future.delayed(const Duration(milliseconds: 2950), () {
      if (!mounted) return;
      setState(() => _hideWhite = true);
    });

    // Step 5 — navigate
    Future.delayed(const Duration(milliseconds: 5600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    });
  }

  @override
  void dispose() {
    _cardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final cx = w / 2;

    return Scaffold(
      body: Stack(
        children: [

          // ── GRADIENT BACKGROUND ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.40, 0.72, 1.0],
                colors: [
                  Color(0xFFB8D8F5),
                  Color(0xFFCBB8F0),
                  Color(0xFFE8B8E0),
                  Color(0xFFF5B0D0),
                ],
              ),
            ),
          ),

          // ── DECORATIVE CIRCLES ──────────────────────────────────────────
          Positioned(
            right: -w * 0.35, top: -h * 0.10,
            child: _circle(w * 0.80, const Color(0xFFF472B6), 0.80),
          ),
          Positioned(
            right: -w * 0.14, top: -h * 0.16,
            child: _circle(w * 0.60, const Color(0xFFFB7185), 0.60),
          ),
          Positioned(
            left: -w * 0.40, bottom: -h * 0.10,
            child: _circle(w * 0.80, const Color(0xFFA78BFA), 0.75),
          ),
          Positioned(
            left: -w * 0.10, bottom: -h * 0.20,
            child: _circle(w * 0.60, const Color(0xFF818CF8), 0.55),
          ),
          Positioned(
            right: -w * 0.24, bottom: -h * 0.08,
            child: _circle(w * 0.56, const Color(0xFFF9A8D4), 0.65),
          ),
          Positioned(
            right: -w * 0.49, bottom: h * 0.20,
            child: _circle(w * 0.60, const Color(0xFFC084FC), 0.60),
          ),
          Positioned(
            right: -w * 0.49, bottom: h * 0.40,
            child: _circle(w * 0.60, const Color(0xFFF9A8D4), 0.60),
          ),

          // White dots
          Positioned(right: w * 0.20, top: h * 0.22, child: _whiteDot(18)),
          Positioned(right: w * 0.32, top: h * 0.30, child: _whiteDot(14)),
          Positioned(left: w * 0.20, bottom: h * 0.22, child: _whiteDot(16)),

          // ── PHASE 2: MAIN UI ────────────────────────────────────────────
          AnimatedOpacity(
            opacity: _showMainUI ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'MaintainIQ',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B4B),
                        fontFamily: 'serif',
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Annual software maintenance estimator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3C3A72),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomPaint(
                      size: const Size(110, 12),
                      painter: _WavyLinePainter(),
                    ),
                    const SizedBox(height: 22),
                    ..._buildPills(),
                  ],
                ),
              ),
            ),
          ),

          // ── PHASE 1: WHITE SCREEN with dot → ripple animation ───────────
          if (!_hideWhite)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [

                // White background
                Container(color: Colors.white),

                // Logo + text (behind dot visually via stack order — dot renders after)
                AnimatedOpacity(
                  opacity: _isScaleCircle ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 140,
                        height: 140,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'MaintainIQ',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: Color(0xFF1E1B4B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Single dot: slides from left into logo center, then ripples out
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  // logo center Y = h/2 - (text ~22 + gap 2 + half logo 70) / 2 => h/2 - 47
                  top: h / 2 - 47 - 12,
                  left: _isDotCenter
                      ? cx - 12
                      : -48,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeInCubic,
                    scale: _isScaleCircle ? 60 : 1,
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: _hideWhite ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7F48BD).withOpacity(0.45),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPills() {
    final pills = [
      'COCOMO-based cost model',
      '5+ year lifecycle planning',
      'Role-based access control',
    ];
    return List.generate(pills.length, (i) => FadeTransition(
      opacity: _cardAnims[i],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(_cardAnims[i]),
        child: Container(
          width: 250,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.42),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
          child: Text(
            pills[i],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E1B4B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ));
  }

  Widget _circle(double size, Color color, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(opacity),
    ),
  );

  Widget _whiteDot(double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.65),
    ),
  );
}

class _WavyLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C6ED4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height / 2);
    path.quadraticBezierTo(
        size.width * 0.75, size.height, size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}