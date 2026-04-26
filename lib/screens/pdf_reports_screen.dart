import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:maintainiq/constants/colors.dart';
import 'package:maintainiq/models/estimation_model.dart';
import 'package:maintainiq/services/firestore_service.dart';
import 'package:maintainiq/services/notification_service.dart';
import 'package:maintainiq/services/pdf_service.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';

class PdfReportsScreen extends StatefulWidget {
  const PdfReportsScreen({super.key});

  @override
  State<PdfReportsScreen> createState() => _PdfReportsScreenState();
}

class _PdfReportsScreenState extends State<PdfReportsScreen> {
  bool _isPKR = false;
  static const double _usdToPkr = 278.5;

  String _fmt(double val) {
    final amount = _isPKR ? val * _usdToPkr : val;
    final prefix = _isPKR ? '₨' : '\$';
    if (amount >= 1000000) return '$prefix${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '$prefix${(amount / 1000).toStringAsFixed(1)}K';
    return '$prefix${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 130,
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
                    size: const Size(double.infinity, 55),
                    painter: _HeaderWavesPainter(),
                  ),
                ),
                Positioned(
                  top: -40, right: -30,
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
                  top: 0, right: 0,
                  child: CustomPaint(
                    size: const Size(50, 130),
                    painter: _SCurvePainter(),
                  ),
                ),
                Positioned(
                  top: 50, right: 60,
                  child: Container(
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.42),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.65)),
                              ),
                              child: const Icon(Icons.arrow_back_rounded,
                                  color: Color(0xFF3c3a72), size: 18),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.42),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: Colors.white.withOpacity(0.65)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFa78bfa).withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.picture_as_pdf_rounded,
                                color: Color(0xFF7c6ed4), size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PDF Reports',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'serif',
                                        color: Color(0xFF1e1b4b))),
                                Text('Tap to open actual PDF report',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF6b6b8a))),
                              ],
                            ),
                          ),
                          _CurrencyToggle(
                            isPKR: _isPKR,
                            onToggle: (val) => setState(() => _isPKR = val),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<EstimationModel>>(
              stream: firestore.getEstimations(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF7c6ed4)));
                }
                if (!snap.hasData || snap.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFf0ebff),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFa78bfa).withOpacity(0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.picture_as_pdf_rounded,
                              color: Color(0xFF7c6ed4), size: 44),
                        ),
                        const SizedBox(height: 16),
                        const Text('No PDF reports yet',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1e1b4b))),
                        const SizedBox(height: 6),
                        const Text(
                          'Generate a cost estimate first,\nthen open its PDF from here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Color(0xFF6b6b8a), height: 1.5),
                        ),
                      ],
                    ),
                  );
                }

                final list = snap.data!;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final isLast = i == list.length - 1;
                    return _TimelineItem(
                      estimation: list[i],
                      firestore: firestore,
                      isLast: isLast,
                      isPKR: _isPKR,
                      fmt: _fmt,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyToggle extends StatelessWidget {
  final bool isPKR;
  final ValueChanged<bool> onToggle;
  const _CurrencyToggle({required this.isPKR, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('USD', !isPKR, () => onToggle(false)),
          _toggleBtn('PKR', isPKR, () => onToggle(true)),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7c6ed4) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF3c3a72))),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final EstimationModel estimation;
  final FirestoreService firestore;
  final bool isLast;
  final bool isPKR;
  final String Function(double) fmt;

  const _TimelineItem({
    required this.estimation,
    required this.firestore,
    required this.isLast,
    required this.isPKR,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 13, height: 13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFa78bfa), Color(0xFFf472b6)],
                    ),
                    border: Border.all(color: const Color(0xFFf8f7ff), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFa78bfa).withOpacity(0.35),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x73a78bfa), Color(0x2ef472b6)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: isLast ? 0 : 8),
              child: _PdfCard(
                estimation: estimation,
                firestore: firestore,
                isPKR: isPKR,
                fmt: fmt,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfCard extends StatefulWidget {
  final EstimationModel estimation;
  final FirestoreService firestore;
  final bool isPKR;
  final String Function(double) fmt;

  const _PdfCard({
    required this.estimation,
    required this.firestore,
    required this.isPKR,
    required this.fmt,
  });

  @override
  State<_PdfCard> createState() => _PdfCardState();
}

class _PdfCardState extends State<_PdfCard> {
  bool _opening = false;

  EstimationModel get e => widget.estimation;

  Color _sizeColor(String size) {
    switch (size) {
      case 'Small':      return const Color(0xFF22c55e);
      case 'Medium':     return const Color(0xFF7c6ed4);
      case 'Large':      return const Color(0xFFf472b6);
      case 'Enterprise': return const Color(0xFFef4444);
      default:           return const Color(0xFF7c6ed4);
    }
  }

  Future<void> _openPdf() async {
    setState(() => _opening = true);
    try {
      final pdfBytes = await PdfService().generatePdfBytes(e, isPKR: widget.isPKR);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => Uint8List.fromList(pdfBytes),
        name: '${e.softwareName.toLowerCase().replaceAll(' ', '_')}_maintenance_report.pdf',
      );
      await NotificationService().showLocalNotification(
        title: '📄 PDF Opened',
        body: '${e.softwareName} report is ready.',
      );
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $err'),
            backgroundColor: const Color(0xFFef4444)));
      }
    }
    if (mounted) setState(() => _opening = false);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Report?'),
        content: Text('"${e.softwareName}" will be permanently deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await widget.firestore.deleteEstimation(e.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Report deleted'),
                      backgroundColor: Color(0xFFef4444)));
                }
              },
              child: const Text('Delete',
                  style: TextStyle(color: Color(0xFFef4444)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFddd6fe)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFa78bfa).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFf0ebff),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFa78bfa).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: Color(0xFF7c6ed4), size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.softwareName,
                          style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1e1b4b))),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _tag(e.softwareSize, _sizeColor(e.softwareSize)),
                          const SizedBox(width: 5),
                          _tag(e.softwareType, const Color(0xFF7c6ed4)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.fmt(e.totalCost),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7c6ed4))),
                    Text('${e.years} years',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF9ca3af))),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(13, 0, 13, 10),
            child: Wrap(
              spacing: 6,
              children: [
                _chip(Icons.calendar_today_rounded, '${e.years} yr projection', const Color(0xFF7c6ed4)),
                _chip(Icons.speed_rounded, 'Complexity ${e.complexity}/10', const Color(0xFFf472b6)),
                _chip(Icons.people_rounded, '${e.teamSize} devs', const Color(0xFF22c55e)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(13, 0, 13, 10),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_rounded, size: 12, color: Color(0xFF7c6ed4)),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${e.softwareName.toLowerCase().replaceAll(' ', '_')}_maintenance_report.pdf',
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF7c6ed4), fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFf4f0ff)),

          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _actionBtn(
                    icon: Icons.visibility_rounded,
                    label: _opening ? 'Opening...' : 'View PDF',
                    color: const Color(0xFF7c6ed4),
                    bg: const Color(0xFFf7f5ff),
                    onTap: _openPdf,
                    loading: _opening,
                  ),
                ),
                const SizedBox(width: 1, height: 38, child: ColoredBox(color: Color(0xFFf4f0ff))),
                Expanded(
                  child: _actionBtn(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete',
                    color: const Color(0xFFdc2626),
                    bg: const Color(0xFFfff5f5),
                    onTap: _confirmDelete,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        color: bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading
                ? SizedBox(
                    width: 11, height: 11,
                    child: CircularProgressIndicator(strokeWidth: 1.8, color: color))
                : Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _HeaderWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint3 = Paint()..color = Colors.white.withOpacity(0.12)..style = PaintingStyle.fill;
    final p3 = Path()
      ..moveTo(0, h * 0.60)
      ..cubicTo(w * 0.25, h * 0.30, w * 0.50, h * 0.80, w * 0.75, h * 0.40)
      ..cubicTo(w * 0.88, h * 0.20, w * 0.95, h * 0.55, w, h * 0.45)
      ..lineTo(w, h)..lineTo(0, h)..close();
    canvas.drawPath(p3, paint3);

    final paint2 = Paint()..color = Colors.white.withOpacity(0.18)..style = PaintingStyle.fill;
    final p2 = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.20, h * 0.45, w * 0.45, h * 0.90, w * 0.65, h * 0.55)
      ..cubicTo(w * 0.80, h * 0.30, w * 0.92, h * 0.65, w, h * 0.58)
      ..lineTo(w, h)..lineTo(0, h)..close();
    canvas.drawPath(p2, paint2);

    final paint1 = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final p1 = Path()
      ..moveTo(0, h * 0.85)
      ..cubicTo(w * 0.22, h * 0.58, w * 0.48, h * 1.05, w * 0.70, h * 0.70)
      ..cubicTo(w * 0.84, h * 0.50, w * 0.93, h * 0.78, w, h * 0.72)
      ..lineTo(w, h)..lineTo(0, h)..close();
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
      ..cubicTo(size.width * 0.3, size.height * 0.25, size.width * 0.75, size.height * 0.5, size.width * 0.3, size.height)
      ..lineTo(size.width, size.height)..close();
    final path2 = Path()
      ..moveTo(size.width, 0)
      ..cubicTo(size.width * 0.45, size.height * 0.22, size.width * 0.88, size.height * 0.48, size.width * 0.45, size.height)
      ..lineTo(size.width, size.height)..close();
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}