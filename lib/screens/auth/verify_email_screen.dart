import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _checkTimer;
  bool _canResend = true;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        _checkTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    setState(() { _canResend = false; _countdown = 60; });
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6358C8), Color(0xFF8B82E8)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.mark_email_unread_rounded,
                  color: Colors.white, size: 44),
              ),
              const SizedBox(height: 28),
              const Text('Verify your email',
                style: TextStyle(fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Text(
                'Email verification link sent:\n$email\n\n'
                'Check your inbox or spam folder and click the link',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14, height: 1.7),
              ),
              const SizedBox(height: 36),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 12),
              const Text('Waiting for verification...',
                style: TextStyle(color: AppColors.textSecondary,
                  fontSize: 12)),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _canResend ? _resend : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _canResend
                      ? 'Resend Verification Link'
                      : 'Resend Link ($_countdown sec)',
                    style: TextStyle(
                      color: _canResend
                        ? AppColors.primary : AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Back to Login',
                  style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}