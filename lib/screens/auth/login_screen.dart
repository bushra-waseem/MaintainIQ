import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _obscure = true;
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
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) {
      setState(() => _error = 'Please enter all fields');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await _auth.login(
      email: _email.text.trim(),
      password: _pass.text,
    );
    setState(() {
      _loading = false;
      _error = err;
    });
  }

  Future<void> _googleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await _auth.signInWithGoogle();
    setState(() {
      _loading = false;
      _error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Decorative blobs (Image 1 style) ──────────────────────────────
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
          // ──────────────────────────────────────────────────────────────────

          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height - MediaQuery.of(context).padding.top,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 160),

                          // ── Centered Heading (Image 2 style) ────────────
                          const Text(
                            'Login',
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
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFa0a0b0),
                            ),
                          ),
                          const SizedBox(height: 40),
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
                                  color: Color(0xFFe53935),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],

                          // Email field
                          _MinimalField(
                            controller: _email,
                            hint: 'Username',
                            icon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),

                          // Password field
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
                          const SizedBox(height: 10),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _showForgotPassword,
                              child: const Text(
                                'Forget Password?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7c6ed4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Login button
                          _PurpleButton(
                            label: 'Login',
                            loading: _loading,
                            onPressed: _login,
                          ),
                          const SizedBox(height: 18),

                          // Divider
                          Row(children: [
                            const Expanded(
                                child: Divider(color: Color(0xFFe0e0f0))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 13)),
                            ),
                            const Expanded(
                                child: Divider(color: Color(0xFFe0e0f0))),
                          ]),
                          const SizedBox(height: 18),

                          // Google button
                          _GoogleButton(
                            loading: _loading,
                            onPressed: _googleLogin,
                          ),
                          const SizedBox(height: 24),

                          // Register link
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            ),
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Color(0xFFa0a0b0),
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF7c6ed4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
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

  void _showForgotPassword() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Password Reset',
            style: TextStyle(color: Color(0xFF7c6ed4))),
        content: TextField(
          controller: emailCtrl,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFFa0a0b0))),
          ),
          TextButton(
            onPressed: () async {
              final err =
                  await _auth.forgotPassword(emailCtrl.text.trim());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    err ?? 'Password reset link sent to your email.'),
                backgroundColor:
                    err == null ? AppColors.success : AppColors.error,
              ));
            },
            child: const Text('Send',
                style: TextStyle(color: Color(0xFF7c6ed4))),
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
        hintStyle: const TextStyle(color: Color(0xFFb0b0c8), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFb0b0c8), size: 20),
        suffixIcon: suffixIcon,
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFdedef0), width: 1.2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF7c6ed4), width: 1.8),
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

class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _GoogleButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFdedef0), width: 1.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'G',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(
                color: Color(0xFF555570),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}