import 'package:flutter/material.dart';
import 'package:maintainiq/constants/colors.dart';
import 'package:maintainiq/services/firestore_service.dart';
import 'package:maintainiq/models/estimation_model.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────
          SizedBox(
            height: 160,
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
                    size: const Size(double.infinity, 70),
                    painter: _HeaderWavesPainter(),
                  ),
                ),
                Positioned(
                  top: -30, right: -20,
                  child: Container(
                    width: 130, height: 120,
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
                  bottom: 30, left: -40,
                  child: Container(
                    width: 110, height: 100,
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
                    size: const Size(50, 160),
                    painter: _SCurvePainter(),
                  ),
                ),
                // White dots (same as home screen)
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
                          const Text(
                            'Insights',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif',
                              color: Color(0xFF1e1b4b),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Smart tips & your project stats',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF3c3a72).withOpacity(0.9),
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
          // ────────────────────────────────────────────────────────────────

          Expanded(
            child: StreamBuilder<List<EstimationModel>>(
              stream: firestore.getEstimations(),
              builder: (context, snap) {
                final estimations = snap.data ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if (estimations.isNotEmpty) ...[
                        _StatsRow(estimations: estimations),
                        const SizedBox(height: 20),
                      ],

                      const _SectionTitle(title: '💡 Maintenance Tips'),
                      const SizedBox(height: 10),
                      const _TipCard(
                        icon: Icons.bug_report_rounded,
                        color: Color(0xFF7c6ed4),
                        bgColor: Color(0xFFf5f3ff),
                        title: 'Reduce Technical Debt Early',
                        body:
                          'Technical debt compounds over time. Every point of '
                          'technical debt increases annual maintenance cost by ~3%. '
                          'Refactor regularly to save long-term.',
                      ),
                      const _TipCard(
                        icon: Icons.trending_up_rounded,
                        color: Color(0xFFf472b6),
                        bgColor: Color(0xFFfdf2f8),
                        title: 'Age Factor is Real',
                        body:
                          'Older software costs 4% more per year to maintain. '
                          'A 10-year-old system costs ~40% more than a new one. '
                          'Plan modernization budgets accordingly.',
                      ),
                      const _TipCard(
                        icon: Icons.group_rounded,
                        color: Color(0xFFa78bfa),
                        bgColor: Color(0xFFf5f0ff),
                        title: 'Team Size vs Complexity',
                        body:
                          'Enterprise systems need larger teams. For every 2 '
                          'complexity points above 6, consider adding 1 dedicated '
                          'maintenance engineer.',
                      ),
                      const _TipCard(
                        icon: Icons.architecture_rounded,
                        color: Color(0xFF60a8d4),
                        bgColor: Color(0xFFeff8fe),
                        title: 'When to Rebuild vs Maintain?',
                        body:
                          'If total maintenance cost over 3 years exceeds the '
                          'original development cost, rebuilding is often more '
                          'economical. Use our estimator to check!',
                      ),
                      const _TipCard(
                        icon: Icons.security_rounded,
                        color: Color(0xFFf472b6),
                        bgColor: Color(0xFFfdf2f8),
                        title: 'Security Maintenance is Mandatory',
                        body:
                          'Budget at least 20% of maintenance cost for security '
                          'patches and updates. Unpatched systems are the #1 '
                          'cause of enterprise data breaches.',
                      ),

                      const SizedBox(height: 20),
                      const _SectionTitle(title: '📊 COCOMO II Formula'),
                      const SizedBox(height: 10),
                      _FormulaCard(),

                      const SizedBox(height: 20),
                      const _SectionTitle(title: '📝 Quick Rules of Thumb'),
                      const SizedBox(height: 10),
                      _RulesCard(),

                      if (estimations.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const _SectionTitle(title: '🏆 Your Top Estimates'),
                        const SizedBox(height: 10),
                        ..._topEstimates(estimations, context),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _topEstimates(
      List<EstimationModel> list, BuildContext context) {
    final sorted = [...list]
      ..sort((a, b) => b.totalCost.compareTo(a.totalCost));
    final top = sorted.take(3).toList();
    return top.map((e) => _EstimateInsightCard(estimation: e)).toList();
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Text(title,
    style: const TextStyle(fontSize: 15,
      fontWeight: FontWeight.bold, color: AppColors.textPrimary));
}

class _StatsRow extends StatelessWidget {
  final List<EstimationModel> estimations;
  const _StatsRow({required this.estimations});

  @override
  Widget build(BuildContext context) {
    final totalProjects = estimations.length;
    final totalBudget = estimations.fold(0.0, (s, e) => s + e.totalCost);
    final avgCost = totalBudget / totalProjects;

    return Row(
      children: [
        _StatBox(
          label: 'Projects',
          value: '$totalProjects',
          icon: Icons.folder_rounded,
          color: AppColors.primary,
          bg: AppColors.primaryLight,
        ),
        const SizedBox(width: 10),
        _StatBox(
          label: 'Avg Cost',
          value: _fmt(avgCost),
          icon: Icons.attach_money_rounded,
          color: AppColors.success,
          bg: AppColors.successLight,
        ),
        const SizedBox(width: 10),
        _StatBox(
          label: 'Total Budget',
          value: _fmt(totalBudget),
          icon: Icons.account_balance_rounded,
          color: AppColors.warning,
          bg: AppColors.warningLight,
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color, bg;
  const _StatBox({
    required this.label, required this.value,
    required this.icon, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value,
              style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.bold, color: color)),
            Text(label,
              style: const TextStyle(fontSize: 10,
                color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title, body;
  const _TipCard({
    required this.icon, required this.color,
    required this.bgColor,
    required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(body,
                  style: TextStyle(fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                    height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFeff8fe),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF60a8d4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Annual Maintenance Cost =',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'DevCost × BaseRate × SizeFactor × AgeFactor × Inflation',
              style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF60a8d4),
                fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 10),
          _fRow('BaseRate', '15% + (Complexity×2.5%) + (TechDebt×3%)'),
          _fRow('AgeFactor', '1.0 + (Age × 0.04)'),
          _fRow('SizeFactor', 'Small=1.0 / Medium=1.3 / Large=1.6 / Enterprise=2.0'),
          _fRow('Inflation', '3% compounded per year'),
        ],
      ),
    );
  }

  Widget _fRow(String k, String v) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(k,
            style: const TextStyle(fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF60a8d4))),
        ),
        Expanded(
          child: Text('= $v',
            style: const TextStyle(fontSize: 11,
              color: Color(0xFFbae0f5))),
        ),
      ],
    ),
  );
}

class _RulesCard extends StatelessWidget {
  final _rules = const [
    ('🟢', 'Cost < 1.5× dev cost', 'Healthy — continue maintenance'),
    ('🟡', 'Cost 1.5–3× dev cost', 'High — refactor & reduce tech debt'),
    ('🔴', 'Cost > 3× dev cost', 'Critical — consider rebuilding system'),
    ('📅', '15% of dev cost/year', 'Industry standard maintenance budget'),
    ('👥', '5–10% team on maintenance', 'Recommended team allocation'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f0ff),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromARGB(255, 213, 147, 247)),
      ),
      child: Column(
        children: _rules.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: i < _rules.length - 1
                ? const Border(bottom: BorderSide(color: Color.fromARGB(255, 213, 147, 247)))
                : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.$1, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.$2,
                        style: const TextStyle(fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                      Text(r.$3,
                        style: const TextStyle(fontSize: 11,
                          color: Color(0xFFa78bfa))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EstimateInsightCard extends StatelessWidget {
  final EstimationModel estimation;
  const _EstimateInsightCard({required this.estimation});

  String _fmt(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  Color get _health {
    final ratio = estimation.totalCost / estimation.devCost;
    if (ratio > 3) return AppColors.error;
    if (ratio > 1.5) return AppColors.warning;
    return AppColors.success;
  }

  String get _healthLabel {
    final ratio = estimation.totalCost / estimation.devCost;
    if (ratio > 3) return 'Critical';
    if (ratio > 1.5) return 'High Cost';
    return 'Healthy';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _health.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: _health.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.computer_rounded, color: _health, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(estimation.softwareName,
                  style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
                Text('${estimation.years} yr projection • ${estimation.softwareSize}',
                  style: const TextStyle(fontSize: 11,
                    color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_fmt(estimation.totalCost),
                style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.bold, color: _health)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _health.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(_healthLabel,
                  style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.w600, color: _health)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── PAINTERS ─────────────────────────────────────────────────────────────────

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