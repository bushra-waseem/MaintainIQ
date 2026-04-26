import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/estimation_model.dart';
import '../services/cost_calculator.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'result_screen.dart';

class EstimationScreen extends StatefulWidget {
  const EstimationScreen({super.key});
  @override
  State<EstimationScreen> createState() => _EstimationScreenState();
}

class _EstimationScreenState extends State<EstimationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _devCostCtrl = TextEditingController();
  final _firestore = FirestoreService();

  String _size = 'Medium';
  String _type = 'Web';
  String _language = 'JavaScript';
  int _age = 3;
  int _teamSize = 5;
  int _complexity = 5;
  int _techDebt = 5;
  int _years = 5;
  bool _loading = false;

  String _currency = 'USD';
  static const double _pkrRate = 278.0;

  double _toUsd(double val) =>
      _currency == 'PKR' ? val / _pkrRate : val;

  final _sizes = ['Small', 'Medium', 'Large', 'Enterprise'];
  final _types = ['Web', 'Mobile', 'Desktop', 'Embedded', 'Cloud'];
  final _languages = [
    'JavaScript', 'Python', 'Java', 'C#', 'PHP',
    'Swift', 'Kotlin', 'Dart', 'C++', 'Other'
  ];

  String _formatCost(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final rawCost = double.tryParse(_devCostCtrl.text) ?? 0;
    final devCostUsd = _toUsd(rawCost);

    final result = CostCalculator.calculate(
      devCost: devCostUsd,
      age: _age,
      size: _size,
      complexity: _complexity,
      techDebt: _techDebt,
      years: _years,
    );

    final estimation = EstimationModel(
      softwareName: _nameCtrl.text.trim(),
      softwareAge: _age,
      softwareSize: _size,
      softwareType: _type,
      language: _language,
      teamSize: _teamSize,
      devCost: devCostUsd,
      complexity: _complexity,
      techDebt: _techDebt,
      years: _years,
      totalCost: result['totalCost'],
      yearlyBreakdown: result['yearlyBreakdown'],
      recommendation: result['recommendation'],
      createdAt: DateTime.now(),
      currency: _currency,
    );

    await _firestore.saveEstimation(estimation);

    await NotificationService().showLocalNotification(
      title: '✅ Estimate Ready — ${estimation.softwareName}',
      body: 'Total ${estimation.years}-year maintenance cost: '
          '\$${_formatCost(estimation.totalCost)}',
    );

    setState(() => _loading = false);

    if (mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ResultScreen(estimation: estimation)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: Stack(
              children: [
                // Pastel gradient background
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
                // Glow top right
                Positioned(
                  top: -30,
                  right: -20,
                  child: Container(
                    width: 130,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        Colors.white.withOpacity(0.45),
                        const Color(0xFFf472b6).withOpacity(0.2),
                      ]),
                    ),
                  ),
                ),
                // Wave painter at bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 60),
                    painter: _HeaderWavePainter(),
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
                // Content
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Row(
                        children: [
                          // Back button
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cost Estimation',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'serif',
                                        color: Color(0xFF1e1b4b))),
                                SizedBox(height: 2),
                                Text('Enter software details',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3c3a72))),
                              ],
                            ),
                          ),
                          // Currency toggle
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.65)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: ['USD', 'PKR'].map((cur) {
                                final selected = _currency == cur;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _currency = cur;
                                    _devCostCtrl.clear();
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF7c6ed4)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(cur,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : const Color(0xFF3c3a72))),
                                  ),
                                );
                              }).toList(),
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

          // ── FORM ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _sectionTitle('Basic Information'),
                    _card(children: [
                      _inputField(
                        ctrl: _nameCtrl,
                        label: 'Software Name',
                        hint: 'For example: Hospital Management System',
                        icon: Icons.computer_rounded,
                        validator: (v) =>
                            v!.isEmpty ? 'Please enter the name first' : null,
                      ),
                      const SizedBox(height: 14),
                      _dropdownField('Software Type', _type, _types,
                          (v) => setState(() => _type = v!)),
                      const SizedBox(height: 14),
                      _dropdownField('Language', _language, _languages,
                          (v) => setState(() => _language = v!)),
                      const SizedBox(height: 14),
                      _dropdownField('Software Size', _size, _sizes,
                          (v) => setState(() => _size = v!)),
                    ]),

                    _sectionTitle('Cost Details'),
                    _card(children: [
                      _inputField(
                        ctrl: _devCostCtrl,
                        label: 'Development Cost ($_currency)',
                        hint: _currency == 'PKR'
                            ? 'e.g. 2,780,000'
                            : 'e.g. 10,000',
                        icon: Icons.attach_money_rounded,
                        type: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? 'Please enter development cost' : null,
                      ),
                    ]),

                    _sectionTitle('Team & Age'),
                    _card(children: [
                      _sliderField(
                        label: 'Software Age',
                        value: _age.toDouble(),
                        min: 1, max: 20,
                        display: '$_age years',
                        color: const Color(0xFF7c6ed4),
                        onChanged: (v) => setState(() => _age = v.round()),
                      ),
                      const SizedBox(height: 4),
                      _sliderField(
                        label: 'Team Size',
                        value: _teamSize.toDouble(),
                        min: 1, max: 50,
                        display: '$_teamSize devs',
                        color: const Color(0xFFf472b6),
                        onChanged: (v) =>
                            setState(() => _teamSize = v.round()),
                      ),
                    ]),

                    _sectionTitle('Complexity & Debt'),
                    _card(children: [
                      _sliderField(
                        label: 'Complexity',
                        value: _complexity.toDouble(),
                        min: 1, max: 10,
                        display: '$_complexity / 10',
                        color: _complexity > 6
                            ? const Color(0xFFf472b6)
                            : const Color(0xFF7c6ed4),
                        onChanged: (v) =>
                            setState(() => _complexity = v.round()),
                      ),
                      const SizedBox(height: 4),
                      _sliderField(
                        label: 'Technical Debt',
                        value: _techDebt.toDouble(),
                        min: 1, max: 10,
                        display: '$_techDebt / 10',
                        color: _techDebt > 6
                            ? const Color(0xFFf472b6)
                            : const Color(0xFFa78bfa),
                        onChanged: (v) =>
                            setState(() => _techDebt = v.round()),
                      ),
                    ]),

                    _sectionTitle('Projection Period'),
                    _card(children: [
                      _sliderField(
                        label: 'Years to Project',
                        value: _years.toDouble(),
                        min: 1, max: 15,
                        display: '$_years years',
                        color: const Color(0xFF60a8d4),
                        onChanged: (v) =>
                            setState(() => _years = v.round()),
                      ),
                    ]),

                    const SizedBox(height: 10),

                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7c6ed4),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: _loading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.calculate_rounded),
                        label: Text(
                          _loading ? 'Calculating...' : 'Generate Estimate',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
    child: Text(title,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3c3a72),
            letterSpacing: 0.5)),
  );

  Widget _card({required List<Widget> children}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 4),
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
        crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _inputField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF3c3a72))),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 13, color: Color(0xFFa78bfa)),
            prefixIcon:
                Icon(icon, color: const Color(0xFF7c6ed4), size: 19),
            filled: true,
            fillColor: const Color(0xFFF7F5FF),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFddd6fe))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFddd6fe))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF7c6ed4), width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFf472b6))),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF3c3a72))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F5FF),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFddd6fe))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFddd6fe))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF7c6ed4), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _sliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required String display,
    required ValueChanged<double> onChanged,
    Color color = const Color(0xFF7c6ed4),
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF3c3a72))),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(display,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withOpacity(0.18),
            overlayColor: color.withOpacity(0.1),
            trackHeight: 3,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ── Wave Painter ──────────────────────────────────────────────────────────────
class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..cubicTo(size.width * 0.25, 0, size.width * 0.50, size.height,
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
          size.width * 0.70, size.height * 0.72)
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