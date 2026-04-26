import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/estimation_model.dart';

class PdfService {
  // ── Pastel Colors ─────────────────────────────────────────────────────────
  static const _purple      = PdfColor.fromInt(0xFF7c6ed4);
  static const _purpleLight = PdfColor.fromInt(0xFFf0ebff);
  static const _purpleDark  = PdfColor.fromInt(0xFF1e1b4b);
  static const _green       = PdfColor.fromInt(0xFF22c55e);
  static const _greenLight  = PdfColor.fromInt(0xFFe1f5ee);
  static const _greenDark   = PdfColor.fromInt(0xFF085041);
  static const _grey        = PdfColor.fromInt(0xFF6b6b8a);
  static const _greyLight   = PdfColor.fromInt(0xFFf8f9ff);
  static const _border      = PdfColor.fromInt(0xFFddd6fe);
  static const _white       = PdfColors.white;

  static const double _usdToPkr = 278.5;

  // ── Public Methods ────────────────────────────────────────────────────────

  Future<void> generateAndDownload(EstimationModel e,
      {bool isPKR = false}) async {
    final pdf = pw.Document();
    _buildPdfContent(pdf, e, isPKR: isPKR);
    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: '${e.softwareName}_maintenance_report.pdf',
    );
  }

  Future<List<int>> generatePdfBytes(EstimationModel e,
      {bool isPKR = false}) async {
    final pdf = pw.Document();
    _buildPdfContent(pdf, e, isPKR: isPKR);
    return pdf.save();
  }

  // ── Build PDF ─────────────────────────────────────────────────────────────

  void _buildPdfContent(pw.Document pdf, EstimationModel e,
      {bool isPKR = false}) {
    // ── PAGE 1: Everything except yearly breakdown ─────────────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _header(e, isPKR: isPKR),
            pw.SizedBox(height: 14),
            _totalCostBox(e, isPKR: isPKR),
            pw.SizedBox(height: 16),
            _sectionTitle('Software Details'),
            pw.SizedBox(height: 8),
            _detailsTable(e, isPKR: isPKR),
            pw.SizedBox(height: 16),
            _sectionTitle('COCOMO II Formula'),
            pw.SizedBox(height: 8),
            _formulaBox(),
            pw.Spacer(),
            _footer(),
          ],
        ),
      ),
    );

    // ── PAGE 2: Year by Year Breakdown + Recommendation ───────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _header(e, isPKR: isPKR),
            pw.SizedBox(height: 16),
            _sectionTitle('Year by Year Breakdown'),
            pw.SizedBox(height: 8),
            _yearlyTable(e, isPKR: isPKR),
            pw.SizedBox(height: 16),
            _recommendationBox(e),
            pw.Spacer(),
            _footer(),
          ],
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────

  pw.Widget _header(EstimationModel e, {bool isPKR = false}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [
            PdfColor.fromInt(0xFFb8d8f5),
            PdfColor.fromInt(0xFFcbb8f0),
            PdfColor.fromInt(0xFFf0b8d8),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('MaintainIQ',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: _purpleDark)),
              pw.SizedBox(height: 2),
              pw.Text('Software Maintenance Cost Report',
                  style: pw.TextStyle(fontSize: 10, color: _grey)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(e.softwareName,
                  style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: _purpleDark)),
              pw.SizedBox(height: 2),
              pw.Text(
                'Generated: ${e.createdAt.day.toString().padLeft(2, '0')}/'
                '${e.createdAt.month.toString().padLeft(2, '0')}/'
                '${e.createdAt.year}',
                style: pw.TextStyle(fontSize: 9, color: _grey),
              ),
              pw.SizedBox(height: 2),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: pw.BoxDecoration(
                  color: isPKR
                      ? PdfColor.fromInt(0xFF22c55e)
                      : PdfColor.fromInt(0xFF7c6ed4),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text(
                  isPKR ? 'PKR Report' : 'USD Report',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────────────────

  pw.Widget _footer() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 6),
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: pw.BoxDecoration(
        color: _purpleLight,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
              // FIX 3: Changed "Google Gemini" to "Grok"
              'Generated by MaintainIQ — COCOMO II | AI: Grok',
              style: pw.TextStyle(fontSize: 8, color: _grey)),
          pw.Text('maintainiq.app',
              style: pw.TextStyle(
                  fontSize: 8,
                  color: _purple,
                  fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // ── TOTAL COST BOX ────────────────────────────────────────────────────────

  pw.Widget _totalCostBox(EstimationModel e, {bool isPKR = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: pw.BoxDecoration(
        color: _purpleLight,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Total Maintenance Cost',
                  style: pw.TextStyle(fontSize: 11, color: _grey)),
              pw.SizedBox(height: 3),
              pw.Text('over ${e.years} year projection',
                  style: pw.TextStyle(fontSize: 9, color: _grey)),
            ],
          ),
          pw.Text(_fmtCurrency(e.totalCost, isPKR),
              style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: _purple)),
        ],
      ),
    );
  }

  // ── SECTION TITLE ─────────────────────────────────────────────────────────

  pw.Widget _sectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 28,
          decoration: pw.BoxDecoration(
            color: _purple,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 10, vertical: 7),
            decoration: pw.BoxDecoration(
              color: _purpleLight,
              borderRadius: const pw.BorderRadius.only(
                topRight: pw.Radius.circular(7),
                bottomRight: pw.Radius.circular(7),
              ),
            ),
            child: pw.Text(title,
                style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: _purpleDark)),
          ),
        ),
      ],
    );
  }

  // ── DETAILS TABLE ─────────────────────────────────────────────────────────

  pw.Widget _detailsTable(EstimationModel e, {bool isPKR = false}) {
    final rows = [
      ('Software Name',        e.softwareName),
      ('Software Type',        e.softwareType),
      ('Software Size',        e.softwareSize),
      ('Programming Language', e.language),
      ('Software Age',         '${e.softwareAge} years'),
      ('Team Size',            '${e.teamSize} developers'),
      ('Development Cost',     _fmtCurrency(e.devCost, isPKR)),
      ('Complexity Level',     '${e.complexity}/10'),
      ('Technical Debt',       '${e.techDebt}/10'),
      ('Projection Period',    '${e.years} years'),
      // FIX 1 & 4: Use ASCII-safe currency label, avoid ₨ Unicode glyph
      ('Currency', isPKR ? 'Pakistani Rupee (PKR)' : 'US Dollar (\$)'),
    ];

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final isEven = entry.key.isEven;
          final r = entry.value;
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: pw.BoxDecoration(
              color: isEven ? _white : _greyLight,
              border: isLast
                  ? null
                  : const pw.Border(
                      bottom: pw.BorderSide(
                          color: PdfColor.fromInt(0xFFede9fe))),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(r.$1,
                    style: pw.TextStyle(fontSize: 10, color: _grey)),
                pw.Text(r.$2,
                    style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: _purpleDark)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── FORMULA BOX ───────────────────────────────────────────────────────────

  pw.Widget _formulaBox() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFeff8fe),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColor.fromInt(0xFFbfdbfe)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _fRow('Base Rate',   '15% + (Complexity x 2.5%) + (TechDebt x 3%)'),
          pw.SizedBox(height: 4),
          _fRow('Age Factor',  '1.0 + (Age x 0.04) per year'),
          pw.SizedBox(height: 4),
          _fRow('Size Factor', 'Small=1.0  Medium=1.3  Large=1.6  Enterprise=2.0'),
          pw.SizedBox(height: 4),
          _fRow('Inflation',   '3% compounded per year'),
        ],
      ),
    );
  }

  pw.Widget _fRow(String k, String v) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 68,
          child: pw.Text(k,
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF3b82f6))),
        ),
        pw.Text('= $v',
            style: pw.TextStyle(
                fontSize: 10,
                color: PdfColor.fromInt(0xFF1d4ed8))),
      ],
    );
  }

  // ── YEARLY TABLE ──────────────────────────────────────────────────────────

  pw.Widget _yearlyTable(EstimationModel e, {bool isPKR = false}) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF7c6ed4),
          ),
          children: [
            _cell('Year', header: true),
            _cell('Annual Cost', header: true),
            _cell('Cumulative', header: true),
          ],
        ),
        ...e.yearlyBreakdown.asMap().entries.map((entry) {
          final cumulative = e.yearlyBreakdown
              .take(entry.key + 1)
              .fold(0.0, (a, b) => a + b);
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: entry.key.isEven ? _white : _greyLight,
            ),
            children: [
              _cell('Year ${entry.key + 1}',
                  color: _purple, bold: true),
              _cell(_fmtCurrency(entry.value, isPKR)),
              _cell(_fmtCurrency(cumulative, isPKR),
                  color: _purpleDark, bold: true),
            ],
          );
        }),
      ],
    );
  }

  // ── RECOMMENDATION ────────────────────────────────────────────────────────

  pw.Widget _recommendationBox(EstimationModel e) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _greenLight,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: _green, width: 0.7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Recommendation',
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _greenDark)),
          pw.SizedBox(height: 5),
          pw.Text(e.recommendation,
              style: pw.TextStyle(fontSize: 10, color: _greenDark)),
        ],
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  String _fmtCurrency(double val, bool isPKR) {
    final amount = isPKR ? val * _usdToPkr : val;
    // FIX 1 & 4: Use "Rs." instead of ₨ Unicode glyph to avoid box/cross rendering
    final prefix = isPKR ? 'Rs.' : '\$';
    if (amount >= 1000000)
      return '$prefix${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000)
      return '$prefix${(amount / 1000).toStringAsFixed(1)}K';
    return '$prefix${amount.toStringAsFixed(0)}';
  }

  pw.Widget _cell(String text,
      {bool header = false, PdfColor? color, bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: (header || bold)
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
          color: header ? _white : (color ?? PdfColors.black),
        ),
      ),
    );
  }
}