import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;
  String? _error;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _pass.text.isEmpty ||
        _confirmPass.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }
    if (_pass.text != _confirmPass.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (_pass.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await _auth.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
    );

    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
    } else {
      setState(() => _loading = false);
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.mark_email_read_rounded,
                      color: AppColors.success, size: 30),
                ),
                const SizedBox(height: 16),
                const Text('Email Sent!',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '${_email.text}\nCheck your email for the verification link. '
                  'Please check your inbox and click the link.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7c6ed4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Go to Login'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Decorative blobs ─────────────────────────────────────────────
          Positioned(
            top: -40,
            right: -40,
            child: _Blob(size: 180, color: const Color(0xFFFB7185)),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: _Blob(size: 90, color: const Color(0xFFa78bfa)),
          ),
          Positioned(
            bottom: 60,
            left: -30,
            child: _Blob(size: 120, color:  const Color(0xFFF9A8D4)),
          ),
          Positioned(
            bottom: 10,
            left: 60,
            child: _Blob(size: 60, color: const Color(0xFFcbb8f0)),
          ),
          // ─────────────────────────────────────────────────────────────────

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFf0eeff),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_rounded,
                                  color: Color(0xFF7c6ed4), size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 90),

                        // ── Centered Heading ─────────────────────────────
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7c6ed4),
                            fontFamily: 'serif',
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Create your account',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFa0a0b0),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // ────────────────────────────────────────────────

                        // Error box
                        if (_error != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFfdecea),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                  color: Color(0xFFe53935), fontSize: 13),
                            ),
                          ),
                        ],

                        // Full Name
                        _MinimalField(
                          controller: _name,
                          hint: 'Full Name',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 18),

                        // Email
                        _MinimalField(
                          controller: _email,
                          hint: 'abc@gmail.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),

                        // Password
                        _MinimalField(
                          controller: _pass,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: const Color(0xFFb0b0c0),
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Confirm Password
                        _MinimalField(
                          controller: _confirmPass,
                          hint: 'Confirm Password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: const Color(0xFFb0b0c0),
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Register button
                        _PurpleButton(
                          label: 'Sign Up',
                          loading: _loading,
                          onPressed: _register,
                        ),
                        const SizedBox(height: 24),

                        // Login link
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Color(0xFFa0a0b0),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Here',
                                  style: TextStyle(
                                    color: Color(0xFF7c6ed4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.85),
      ),
    );
  }
}

class _MinimalField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _MinimalField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF333355)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFFb0b0c8), fontSize: 14),
        prefixIcon:
            Icon(icon, color: const Color(0xFFb0b0c8), size: 20),
        suffixIcon: suffixIcon,
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFFdedef0), width: 1.2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFF7c6ed4), width: 1.8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      ),
    );
  }
}

class _PurpleButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PurpleButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7c6ed4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                label,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}