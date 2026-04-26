import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import '../services/gemini_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _gemini = GeminiService();
  final List<Map<String, dynamic>> _messages = [];
  bool _typing = false;

  final _suggestions = [
    'What is the COCOMO model?',
    'How to reduce technical debt?',
    'When should a software be rebuilt?',
    'How to reduce maintenance costs?',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'ai',
      'text': 'Hello! I am MaintainIQ AI 🤖\n\n'
          'I can assist you with software maintenance costs,'
          ' the COCOMO model, technical debt, and ROI analysis.\n\n'
          'Ask me a question',
      'time': _timeNow(),
    });
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _send([String? preset]) async {
    final text = preset ?? _msgCtrl.text.trim();
    if (text.isEmpty) return;

    _msgCtrl.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text, 'time': _timeNow()});
      _typing = true;
    });
    _scrollDown();

    final userName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'User';
    final reply = await _gemini.sendMessage(text,
        projectContext: 'User name: $userName. App: MaintainIQ — '
            'Software Maintenance Cost Estimator using COCOMO II model.');

    setState(() {
      _typing = false;
      _messages.add({'role': 'ai', 'text': reply, 'time': _timeNow()});
    });
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header with Waves ────────────────────────────────────────────
          SizedBox(
            height: 130,
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

                // Waves at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 55),
                    painter: _HeaderWavesPainter(),
                  ),
                ),

                // Glow top right
                Positioned(
                  top: -40,
                  right: -30,
                  child: Container(
                    width: 130,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        Colors.white.withOpacity(0.45),
                        const Color(0xFFf472b6).withOpacity(0.25),
                      ]),
                    ),
                  ),
                ),

                // S-curve right
                Positioned(
                  top: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(50, 130),
                    painter: _SCurvePainter(),
                  ),
                ),

                // Glow dot
                Positioned(
                  top: 50,
                  right: 60,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),

                // Header content
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.42),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.65)),
                              ),
                              child: const Icon(Icons.arrow_back_rounded,
                                  color: Color(0xFF3c3a72), size: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.42),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.65)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFa78bfa)
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: Color(0xFF7c6ed4), size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('MaintainIQ AI',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'serif',
                                      color: Color(0xFF1e1b4b))),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4ADE80),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text('Online — Gemini AI',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: const Color(0xFF3c3a72)
                                              .withOpacity(0.8))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Messages ─────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (_typing && i == _messages.length) return _typingBubble();
                final msg = _messages[i];
                final isUser = msg['role'] == 'user';
                return _messageBubble(
                  text: msg['text'],
                  isUser: isUser,
                  time: msg['time'],
                );
              },
            ),
          ),

          // ── Suggestions ──────────────────────────────────────────────────
          if (_messages.length <= 1)
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _suggestions.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => _send(_suggestions[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf0ebff),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF7c6ed4).withOpacity(0.3)),
                    ),
                    child: Text(_suggestions[i],
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF7c6ed4))),
                  ),
                ),
              ),
            ),

          // ── Input area ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: const Color(0xFFddd6fe))),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFa78bfa).withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Ask me a question...',
                      hintStyle: TextStyle(
                          color: const Color(0xFF6b6b8a).withOpacity(0.7),
                          fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFf5f3ff),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFFddd6fe)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFFddd6fe)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFF7c6ed4), width: 1.5),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _typing ? null : _send,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF818CF8),
                          Color(0xFFa78bfa),
                          Color(0xFFf472b6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFa78bfa).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble({
    required String text,
    required bool isUser,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFFa78bfa)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 15),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF818CF8),
                              Color(0xFF7c6ed4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: const Color(0xFFddd6fe)),
                    boxShadow: [
                      BoxShadow(
                        color: (isUser
                                ? const Color(0xFFa78bfa)
                                : Colors.black)
                            .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser
                          ? Colors.white
                          : const Color(0xFF1e1b4b),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(time,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF6b6b8a))),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _typingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF818CF8), Color(0xFFa78bfa)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 15),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: const Color(0xFFddd6fe)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _dot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (_, val, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: const Color(0xFF7c6ed4)
              .withOpacity(0.4 + (val * 0.6)),
          shape: BoxShape.circle,
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
