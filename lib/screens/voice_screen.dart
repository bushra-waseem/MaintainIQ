import 'package:flutter/material.dart';
import 'package:maintainiq/constants/colors.dart';
import 'package:maintainiq/services/gemini_service.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with TickerProviderStateMixin {
  final GeminiService _gemini = GeminiService();
  final TextEditingController _ctrl = TextEditingController();

  bool _processing = false;
  String _aiReply = '';

  late AnimationController _orbCtrl;
  late Animation<double> _orbAnim;

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _orbAnim = Tween<double>(begin: 0.92, end: 1.08)
      .animate(CurvedAnimation(
        parent: _orbCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _askAI() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() { _processing = true; _aiReply = ''; });
    final reply = await _gemini.sendMessage(text);
    setState(() { _processing = false; _aiReply = reply; });
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEEDFE), Color(0xFFF8F7FF),
              Color(0xFFE8E6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8)],
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary, size: 18),
                      ),
                    ),
                    const Text('AI Assistant',
                      style: TextStyle(fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                    const SizedBox(width: 38),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Orb
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _orbAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _processing ? 1.1 : _orbAnim.value,
                      child: Container(
                        width: 220, height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: _processing
                              ? [
                                  const Color(0xFF7F77DD),
                                  const Color(0xFFB8A9FF),
                                  const Color(0xFF6358C8),
                                  const Color(0xFF9B8FE8),
                                  const Color(0xFF7F77DD),
                                ]
                              : [
                                  const Color(0xFFB8B0F0),
                                  const Color(0xFFD4CFFF),
                                  const Color(0xFF9B95E8),
                                  const Color(0xFFC4BEFF),
                                  const Color(0xFFB8B0F0),
                                ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(
                                _processing ? 0.5 : 0.25),
                              blurRadius: _processing ? 50 : 30,
                              spreadRadius: _processing ? 10 : 0,
                            ),
                          ],
                        ),
                        child: _processing
                          ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3)
                          : const Icon(Icons.auto_awesome_rounded,
                              color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                ),
              ),

              // AI Reply
              if (_aiReply.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10)],
                  ),
                  child: Text(_aiReply,
                    style: const TextStyle(fontSize: 14,
                      color: AppColors.textPrimary, height: 1.5),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 20),

              // Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        decoration: InputDecoration(
                          hintText: 'Ask AI a question...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _processing ? null : _askAI,
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12)],
                        ),
                        child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}