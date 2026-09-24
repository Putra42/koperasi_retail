import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_database.dart';
import 'home_screen.dart';

const _green = Color(0xFF00940F);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _busy = false;

  @override
  void dispose() { _name.dispose(); _identifier.dispose(); _password.dispose(); _confirm.dispose(); super.dispose(); }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final user = await AuthDatabase.instance.register(name: _name.text, identifier: _identifier.text, password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen(user: user)), (_) => false);
    } on DuplicateUserException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau nomor HP sudah terdaftar.')),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Gagal mendaftarkan akun: $error\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pendaftaran gagal (${error.runtimeType}). Lihat Debug Console untuk detail.',
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.white, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), title: Text('Buat Akun', style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w700))),
      body: SafeArea(child: LayoutBuilder(builder: (context, box) => SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 4, 28, 28), child: ConstrainedBox(constraints: BoxConstraints(minHeight: box.maxHeight - 36), child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Image.asset('assets/images/logo.png', width: (width * .36).clamp(130.0, 165.0).toDouble(), height: (width * .36).clamp(130.0, 165.0).toDouble(), fit: BoxFit.contain)),
        Text('Gabung Koperasi', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 23, fontWeight: FontWeight.w800, color: Colors.black)),
        const SizedBox(height: 5),
        Text('Isi data berikut untuk membuat akun', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 24),
        _label('Nama lengkap'), const SizedBox(height: 7),
        _input(_name, 'Nama sesuai identitas', validator: (v) => v == null || v.trim().length < 2 ? 'Masukkan nama lengkap' : null),
        const SizedBox(height: 15), _label('Email atau nomor HP'), const SizedBox(height: 7),
        _input(_identifier, 'contoh@email.com / 08xxxxxxxxxx', keyboard: TextInputType.emailAddress, validator: (v) => v == null || v.trim().isEmpty ? 'Masukkan email atau nomor HP' : null),
        const SizedBox(height: 15), _label('Kata sandi'), const SizedBox(height: 7),
        _input(_password, 'Minimal 6 karakter', obscure: _hidePassword, validator: (v) => v == null || v.length < 6 ? 'Kata sandi minimal 6 karakter' : null, suffix: IconButton(onPressed: () => setState(() => _hidePassword = !_hidePassword), icon: Icon(_hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined))),
        const SizedBox(height: 15), _label('Konfirmasi kata sandi'), const SizedBox(height: 7),
        _input(_confirm, 'Ulangi kata sandi', obscure: _hideConfirm, validator: (v) => v != _password.text ? 'Kata sandi belum sama' : null, suffix: IconButton(onPressed: () => setState(() => _hideConfirm = !_hideConfirm), icon: Icon(_hideConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined))),
        const SizedBox(height: 25),
        SizedBox(height: 49, child: ElevatedButton(onPressed: _busy ? null : _register, style: ElevatedButton.styleFrom(backgroundColor: _green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0), child: _busy ? const SizedBox(width: 21, height: 21, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('Daftar', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Sudah punya akun?', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black54)), TextButton(onPressed: () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: Text('Masuk', style: GoogleFonts.plusJakartaSans(color: _green, fontWeight: FontWeight.w700, fontSize: 12)))]),
      ])))))));
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13));
  Widget _input(TextEditingController controller, String hint, {String? Function(String?)? validator, TextInputType? keyboard, bool obscure = false, Widget? suffix}) => TextFormField(controller: controller, validator: validator, keyboardType: keyboard, obscureText: obscure, decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey.shade500), suffixIcon: suffix, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _green))));
}
