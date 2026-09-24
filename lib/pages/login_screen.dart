import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_database.dart';
import 'home_screen.dart';
import 'register_screen.dart';

const Color primaryGreen = Color(0xFF00940F);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final user = await AuthDatabase.instance.signIn(
        _identifier.text,
        _password.text,
      );
      if (!mounted) return;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email/nomor HP atau kata sandi tidak sesuai.'),
          ),
        );
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        (_) => false,
      );
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun belum terdaftar atau terjadi kesalahan.'),
          ),
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = MediaQuery.sizeOf(context).height < 720;
    const horizontal = 16.0;
    final titleStyle = GoogleFonts.plusJakartaSans(
      fontWeight: FontWeight.w800,
      fontSize: width * .075,
      height: 1.08,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontal,
              compact ? 12 : 28,
              horizontal,
              24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: box.maxHeight - (compact ? 36 : 52),
              ),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: compact ? 0 : 8),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: (width * .43).clamp(145.0, 190.0).toDouble(),
                        height: (width * .43).clamp(145.0, 190.0).toDouble(),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: compact ? 8 : 18),
                    Text(
                      'Koperasi',
                      textAlign: TextAlign.center,
                      style: titleStyle.copyWith(color: Colors.black),
                    ),
                    Text(
                      'Retail Sembako',
                      textAlign: TextAlign.center,
                      style: titleStyle.copyWith(color: primaryGreen),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belanja Kebutuhan pokok\nlebih mudah',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.25,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: compact ? 18 : 30),
                    Text(
                      'Masuk ke Akun Anda',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      controller: _identifier,
                      hint: 'Email / No. Hp',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Masukkan email atau nomor HP'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _field(
                      controller: _password,
                      hint: 'Kata Sandi',
                      obscure: _obscure,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Masukkan kata sandi'
                          : null,
                      suffix: IconButton(
                        tooltip: _obscure
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Silakan hubungi pengelola koperasi untuk bantuan akun.',
                            ),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Lupa kata sandi?',
                          style: GoogleFonts.plusJakartaSans(
                            color: primaryGreen,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 14 : 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: _busy
                            ? const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Masuk',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Daftar di sini',
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscure,
    validator: validator,
    textInputAction: obscure ? TextInputAction.done : TextInputAction.next,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        color: Colors.grey.shade500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryGreen),
      ),
    ),
  );
}
