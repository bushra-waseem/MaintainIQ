import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:maintainiq/constants/colors.dart';
import 'package:maintainiq/models/estimation_model.dart';
import 'package:maintainiq/services/pdf_service.dart';

class ResultScreen extends StatefulWidget {
  final EstimationModel estimation;
  const ResultScreen({super.key, required this.estimation});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _currentCurrency;
  static const double _pkrRate = 278.0;

  @override
  void initState() {
    super.initState();
    _currentCurrency = widget.estimation.currency;
  }

  String _format(double val) {
    bool isPkr = _currentCurrency == 'PKR';
    double displayVal = isPkr ? val * _pkrRate : val;
    String symbol = isPkr ? 'Rs ' : '\$';
    if (displayVal >= 1000000)
      return '$symbol${(displayVal / 1000000).toStringAsFixed(1)}M';
    if (displayVal >= 1000)
      return '$symbol${(displayVal / 1000).toStringAsFixed(1)}K';
    return '$symbol${displayVal.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final pdfService = PdfService();

    return Scaffold(
      backgroundColor:  Colors.white,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────
          SizedBox(
            height: 165,
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
                  top: -30, right: -20,
                  child: Container(
                    width: 130, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        Colors.white.withOpacity(0.45),
                        const Color(0xFFf472b6).withOpacity(0.2),
                      ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 60),
                    painter: _WavePainter(),
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
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.65)),
                              ),
                              child: const Icon(Icons.arrow_back_rounded,
                                  color: Color(0xFF3c3a72), size: 18),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.estimation.softwareName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'serif',
                                        color: Color(0xFF1e1b4b))),
                                const Text('Maintenance Cost Estimate',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3c3a72))),
                              ],
                            ),
                          ),
                          // Currency toggle
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.65)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: ['USD', 'PKR'].map((cur) {
                                final selected = _currentCurrency == cur;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _currentCurrency = cur),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF7c6ed4)
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                    child: Text(cur,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : const Color(0xFF3c3a72))),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          // PDF download
                          GestureDetector(
                            onTap: () async {
                              await pdfService
                                  .generateAndDownload(widget.estimation);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('PDF Downloaded Successfully!'),
                                    backgroundColor: Color(0xFF7c6ed4)));
                            },
                            child: Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.65)),
                              ),
                              child: const Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: Color(0xFF3c3a72), size: 20),
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

          // ── BODY ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  // Total cost card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFcbb8f0), Color(0xFF7c6ed4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                            color:
                                const Color(0xFF7c6ed4).withOpacity(0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('Total Maintenance Cost',
                            style: TextStyle(
                                fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text(_format(widget.estimation.totalCost),
                            style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Over ${widget.estimation.years} years',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white60)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Info grid
                  Row(children: [
                    _infoCard('Size', widget.estimation.softwareSize,
                        const Color(0xFFf0ebff),
                        const Color(0xFF7c6ed4)),
                    const SizedBox(width: 10),
                    _infoCard('Type', widget.estimation.softwareType,
                        const Color(0xFFfdf2f8),
                        const Color(0xFFf472b6)),
                    const SizedBox(width: 10),
                    _infoCard('Age',
                        '${widget.estimation.softwareAge}y',
                        const Color(0xFFeff8fe),
                        const Color(0xFF60a8d4)),
                  ]),

                  const SizedBox(height: 14),

                  // Chart
                  _sectionCard(
                    title: 'Year by Year Breakdown',
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: widget.estimation.yearlyBreakdown
                                  .isNotEmpty
                              ? widget.estimation.yearlyBreakdown
                                      .reduce((a, b) => a > b ? a : b) *
                                  1.2
                              : 100,
                          barGroups: widget.estimation.yearlyBreakdown
                              .asMap()
                              .entries
                              .map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFcbb8f0),
                                            Color(0xFF7c6ed4)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        width: 18,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                    ],
                                  ))
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 45,
                                getTitlesWidget: (v, _) => Text(
                                    _format(v),
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF3c3a72))),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) => Text(
                                    'Y${v.toInt() + 1}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF3c3a72))),
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            getDrawingHorizontalLine: (_) => FlLine(
                                color: const Color(0xFFddd6fe),
                                strokeWidth: 0.5),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Yearly table
                  _sectionCard(
                    title: 'Yearly Cost',
                    child: Column(
                      children: widget.estimation.yearlyBreakdown
                          .asMap()
                          .entries
                          .map((e) => _yearRow(
                              'Year ${e.key + 1}',
                              e.value,
                              e.key ==
                                  widget.estimation.yearlyBreakdown
                                          .length -
                                      1))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Recommendation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf0ebff),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color:
                              const Color(0xFF7c6ed4).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: Color(0xFF7c6ed4), size: 18),
                            SizedBox(width: 8),
                            Text('Recommendation',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7c6ed4))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.estimation.recommendation,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1e1b4b),
                                height: 1.5)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Download PDF button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await pdfService
                            .generateAndDownload(widget.estimation);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7c6ed4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF Report',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
      String label, String value, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF3c3a72))),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFddd6fe)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF7c6ed4).withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1e1b4b))),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _yearRow(String year, double cost, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFddd6fe))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(year,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF3c3a72))),
          Text(_format(cost),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1e1b4b))),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..cubicTo(size.width * 0.25, 0, size.width * 0.5, size.height,
          size.width * 0.75, size.height * 0.4)
      ..cubicTo(size.width * 0.88, size.height * 0.1,
          size.width * 0.95, size.height * 0.6, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path2 = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(size.width * 0.22, size.height * 0.5,
          size.width * 0.48, size.height * 1.1,
          size.width * 0.7, size.height * 0.72)
      ..cubicTo(size.width * 0.84, size.height * 0.52,
          size.width * 0.93, size.height * 0.78, size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}
