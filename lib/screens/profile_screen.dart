import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header with Waves ──────────────────────────────────────────
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // Gradient background
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

                  // Layered waves at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(double.infinity, 100),
                      painter: _HeaderWavesPainter(),
                    ),
                  ),

                  // Glow top right
                  Positioned(
                    top: -40,
                    right: -30,
                    child: Container(
                      width: 160,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          Colors.white.withOpacity(0.45),
                          const Color(0xFFf472b6).withOpacity(0.25),
                        ]),
                      ),
                    ),
                  ),

                  // Glow bottom left
                  Positioned(
                    bottom: 40,
                    left: -50,
                    child: Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          Colors.white.withOpacity(0.4),
                          const Color(0xFFa78bfa).withOpacity(0.3),
                        ]),
                      ),
                    ),
                  ),

                  // S-curve right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(60, 265),
                      painter: _SCurvePainter(),
                    ),
                  ),

                  // Glow dots
                  Positioned(
                    top: 72,
                    right: 72,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 105,
                    right: 105,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),

                  // Profile Content
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.65),
                                    width: 3),
                                color: Colors.white.withOpacity(0.35),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFa78bfa)
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: user?.photoURL != null
                                  ? ClipOval(
                                      child: Image.network(user!.photoURL!,
                                          fit: BoxFit.cover))
                                  : const Icon(Icons.person_rounded,
                                      color: Color(0xFF3c3a72), size: 40),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user?.displayName ?? 'User',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'serif',
                                  color: Color(0xFF1e1b4b)),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF3c3a72)
                                      .withOpacity(0.85)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.42),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.65)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded,
                                      color: const Color(0xFF7c6ed4), size: 14),
                                  const SizedBox(width: 5),
                                  Text(
                                    user?.emailVerified == true
                                        ? 'Email Verified'
                                        : 'Not Verified',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1e1b4b),
                                        fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
              child: Column(
                children: [
                  _sectionTitle('App Info'),
                  _infoCard(children: [
                    _infoRow(Icons.memory_rounded, 'App Name', 'MaintainIQ'),
                    _divider(),
                    _infoRow(Icons.tag_rounded, 'Version', '1.0.0'),
                    _divider(),
                    _infoRow(Icons.functions_rounded, 'Model Used', 'COCOMO II'),
                    _divider(),
                    _infoRow(
                        Icons.smart_toy_rounded, 'AI Powered By', 'Google Gemini'),
                  ]),

                  _sectionTitle('Account'),
                  _infoCard(children: [
                    _infoRow(Icons.email_outlined, 'Email', user?.email ?? ''),
                    _divider(),
                    _infoRow(
                      Icons.shield_outlined,
                      'Account Type',
                      user?.providerData.first.providerId == 'google.com'
                          ? 'Google Account'
                          : 'Email & Password',
                    ),
                  ]),

                  _sectionTitle('About Project'),
                  _infoCard(children: [
                    _infoRow(Icons.school_rounded, 'Project Type',
                        'Software Engineering Project'),
                    _divider(),
                    _infoRow(Icons.topic_rounded, 'Topic',
                        'Software Maintenance Cost Model'),
                    _divider(),
                    _infoRow(Icons.calendar_today_rounded, 'Year', '2026'),
                  ]),

                  const SizedBox(height: 14),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text('Logout?'),
                            content: const Text(
                                'Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Yes, Logout',
                                      style: TextStyle(
                                          color: AppColors.error))),
                            ],
                          ),
                        );
                        if (confirm == true) await auth.logout();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: const Color(0xFF7c6ed4), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor:
                             Color(0xFF7c6ed4),
                      ),
                      icon: const Icon(Icons.logout_rounded,
                          color: Colors.white,),
                      label: const Text('Logout',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(t,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7c6ed4),
                  letterSpacing: 0.5)),
        ),
      );

  Widget _infoCard({required List<Widget> children}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFddd6fe),),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFa78bfa).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: children),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:const Color(0xFF7c6ed4),
              ),
             child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF6b6b8a))),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7c6ed4),)),
          ],
        ),
      );

  Widget _divider() =>
      const Divider(height: 1, color:const Color(0xFFddd6fe),);
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
      ..cubicTo(
        size.width * 0.3, size.height * 0.25,
        size.width * 0.75, size.height * 0.5,
        size.width * 0.3, size.height,
      )
      ..lineTo(size.width, size.height)
      ..close();
    final path2 = Path()
      ..moveTo(size.width, 0)
      ..cubicTo(
        size.width * 0.45, size.height * 0.22,
        size.width * 0.88, size.height * 0.48,
        size.width * 0.45, size.height,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}
