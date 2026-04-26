import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintainiq/constants/colors.dart';
import 'package:maintainiq/services/auth_service.dart';
import 'package:maintainiq/screens/estimation_screen.dart';
import 'package:maintainiq/screens/chatbot_screen.dart';
import 'package:maintainiq/screens/history_screen.dart';
import 'package:maintainiq/screens/profile_screen.dart';
import 'package:maintainiq/screens/pdf_reports_screen.dart';
import 'package:maintainiq/screens/insights_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  final _auth = AuthService();

  String get _userName =>
      FirebaseAuth.instance.currentUser?.displayName ?? 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _tab,
        children: [
          _HomeTab(userName: _userName),
          const HistoryScreen(),
          const SizedBox(),
          const InsightsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        onFabTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatbotScreen()),
        ),
      ),
    );
  }
}

// ─── BOTTOM NAV ──────────────────────────────────────────────────────────────
class _BottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav> with TickerProviderStateMixin {
  // Pulse (breathe) animation
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Tap burst animation
  late AnimationController _tapCtrl;
  late Animation<double> _tapAnim;

  static const _navItems = [
    {'icon': Icons.home_rounded,         'tab': 0},
    {'icon': Icons.history_rounded,      'tab': 1},
    {'icon': Icons.lightbulb_outline_rounded, 'tab': 3},
    {'icon': Icons.person_outline_rounded,    'tab': 4},
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _tapAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFa78bfa).withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Left two nav items
              _navItem(_navItems[0], 0),
              _navItem(_navItems[1], 1),

              // ── Center FAB (inline, same level) ──────────────────────────
              SizedBox(
                width: 72,
                child: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_pulseAnim, _tapAnim]),
                    builder: (_, __) {
                      final scale = _pulseAnim.value * _tapAnim.value;
                      final glowOpacity =
                          0.40 + (_pulseAnim.value - 1.0) * 2.5;
                      final glowBlur =
                          18.0 + (_pulseAnim.value - 1.0) * 28.0;

                      return Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTapDown: (_) => _tapCtrl.forward(),
                          onTapUp: (_) async {
                            await _tapCtrl.reverse();
                            widget.onFabTap();
                          },
                          onTapCancel: () => _tapCtrl.reverse(),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF818CF8),
                                  Color(0xFFa78bfa),
                                  Color(0xFFf472b6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFa78bfa).withOpacity(
                                      glowOpacity.clamp(0.0, 1.0)),
                                  blurRadius: glowBlur,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFf472b6)
                                      .withOpacity(0.20),
                                  blurRadius: 28,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Right two nav items
              _navItem(_navItems[2], 2),
              _navItem(_navItems[3], 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(Map item, int navPos) {
    final tabIndex = item['tab'] as int;
    final icon = item['icon'] as IconData;
    final active = widget.currentIndex == tabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(tabIndex),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: active ? 48 : 42,
              height: active ? 48 : 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? const Color(0xFF7c6ed4).withOpacity(0.12)
                    : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: active ? 28 : 26,
                color: active
                    ? const Color(0xFF7c6ed4)
                    : const Color(0xFFcccccc),
              ),
            ),
            // Active dot indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: active ? 5 : 0,
              height: active ? 5 : 0,
              margin: const EdgeInsets.only(top: 3),
              decoration: const BoxDecoration(
                color: Color(0xFF7c6ed4),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HOME TAB ────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final String userName;
  const _HomeTab({required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFb8d8f5),
                    Color(0xFFcbb8f0),
                    Color(0xFFf0b8d8),
                  ],
                  stops: [0.0, 0.48, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _HeaderWavesPainter(),
            ),
          ),
          Positioned(
            top: -40, right: -30,
            child: Container(
              width: 160, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withOpacity(0.45),
                  const Color(0xFFf472b6).withOpacity(0.25),
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: -50,
            child: Container(
              width: 140, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withOpacity(0.4),
                  const Color(0xFFa78bfa).withOpacity(0.3),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 0, right: 0,
            child: CustomPaint(
              size: const Size(60, 220),
              painter: _SCurvePainter(),
            ),
          ),
          Positioned(
            top: 72, right: 72,
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            top: 105, right: 105,
            child: Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $userName 👋',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1e1b4b),
                                fontFamily: 'serif',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Estimate Software Cost',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF3c3a72).withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const EstimationScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.42),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.65)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 37, height: 37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: const Icon(Icons.description_outlined,
                                  size: 17, color: Color(0xFF3c3a72)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Create new estimate',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1e1b4b))),
                                  SizedBox(height: 1),
                                  Text('Check software maintenance cost',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF3c3a72))),
                                ],
                              ),
                            ),
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.55),
                              ),
                              child: const Icon(Icons.arrow_forward,
                                  size: 13, color: Color(0xFF3c3a72)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard('COCOMO II', 'Model Used', Icons.functions,
                    const Color(0xFF7c6ed4), const Color(0xFFf0ebff),
                    const Color(0xFFddd6fe)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard('5+ Years', 'Projection', Icons.trending_up,
                    const Color(0xFFbe185d), const Color(0xFFfce8f5),
                    const Color(0xFFf9a8d4)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Features',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1e1b4b))),
          const SizedBox(height: 13),
          _featureItem(context, 'Cost Estimation', 'COCOMO II Model',
              Icons.description_outlined, const Color(0xFF7c6ed4),
              const Color(0xFFf5f3ff), const Color(0xFFddd6fe),
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EstimationScreen()))),
          _featureItem(context, 'AI Chatbot', 'Gemini Powered',
              Icons.chat_bubble_outline, const Color(0xFFf472b6),
              const Color(0xFFfdf2f8), const Color(0xFFf9a8d4),
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatbotScreen()))),
          _featureItem(context, 'History', 'Old estimates', Icons.history,
              const Color(0xFFa78bfa), const Color(0xFFf5f0ff),
              const Color(0xFFc4b5fd),
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()))),
          _featureItem(context, 'PDF Report', 'Download full estimate',
              Icons.picture_as_pdf_outlined, const Color(0xFF60a8d4),
              const Color(0xFFeff8fe), const Color(0xFFbae0f5),
              () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => const PdfReportsScreen()))),
        ],
      ),
    );
  }

  Widget _statCard(String title, String sub, IconData icon, Color color,
      Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: border,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 7),
          Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1e1b4b))),
          const SizedBox(height: 1),
          Text(sub, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _featureItem(BuildContext context, String title, String sub,
      IconData icon, Color iconColor, Color bg, Color border,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: iconColor,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1e1b4b))),
                  const SizedBox(height: 2),
                  Text(sub,
                      style: TextStyle(fontSize: 11, color: iconColor)),
                ],
              ),
            ),
            Container(
              width: 26, height: 26,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: border),
              child:
                  Icon(Icons.arrow_forward, size: 12, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PAINTERS ────────────────────────────────────────────────────────────────

class _HeaderWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint3 = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final p3 = Path()
      ..moveTo(0, h * 0.60)
      ..cubicTo(w * 0.25, h * 0.30, w * 0.50, h * 0.80, w * 0.75, h * 0.40)
      ..cubicTo(w * 0.88, h * 0.20, w * 0.95, h * 0.55, w, h * 0.45)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(p3, paint3);

    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    final p2 = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.20, h * 0.45, w * 0.45, h * 0.90, w * 0.65, h * 0.55)
      ..cubicTo(w * 0.80, h * 0.30, w * 0.92, h * 0.65, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(p2, paint2);

    final paint1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final p1 = Path()
      ..moveTo(0, h * 0.85)
      ..cubicTo(w * 0.22, h * 0.58, w * 0.48, h * 1.05, w * 0.70, h * 0.70)
      ..cubicTo(w * 0.84, h * 0.50, w * 0.93, h * 0.78, w, h * 0.72)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(p1, paint1);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _SCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.white.withOpacity(0.18);
    final paint2 = Paint()..color = Colors.white.withOpacity(0.12);
    final path1 = Path()
      ..moveTo(size.width, 0)
      ..cubicTo(size.width * 0.3, size.height * 0.25,
          size.width * 0.75, size.height * 0.5,
          size.width * 0.3, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    final path2 = Path()
      ..moveTo(size.width, 0)
      ..cubicTo(size.width * 0.45, size.height * 0.22,
          size.width * 0.88, size.height * 0.48,
          size.width * 0.45, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}