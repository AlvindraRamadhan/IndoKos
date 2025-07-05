import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _error = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // FIX: This function no longer expects a return value from the provider.
  // It assumes success if no error is thrown.
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _error = 'Password dan konfirmasi password tidak cocok');
        return;
      }

      setState(() {
        _isLoading = true;
        _error = '';
      });

      try {
        await context.read<AuthProvider>().register(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            );

        // This part now runs assuming the registration was successful
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pendaftaran berhasil! Silakan masuk.'),
                backgroundColor: Colors.green),
          );
          context.go('/login');
        }
      } catch (e) {
        // This block will catch any errors if the provider is updated to throw them
        if (mounted) {
          setState(() {
            _error = 'Gagal mendaftar. Terjadi kesalahan.';
          });
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Redesigned UI to match the Login Screen
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home_work_rounded,
                      size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text('IndoKos',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Buat Akun Baru Anda',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error.isNotEmpty) ...[
                            Text(_error,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                          ],
                          const Text("Nama Lengkap",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  hintText: 'Masukkan nama lengkap',
                                  prefixIcon: Icon(Icons.person_outline)),
                              validator: (v) => v!.isEmpty
                                  ? 'Nama tidak boleh kosong'
                                  : null),
                          const SizedBox(height: 16),
                          const Text("Email",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  hintText: 'email@example.com',
                                  prefixIcon: Icon(Icons.mail_outline)),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty
                                  ? 'Email tidak boleh kosong'
                                  : null),
                          const SizedBox(height: 16),
                          const Text("Password",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Minimal 8 karakter',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => v!.length < 8
                                ? 'Password minimal 8 karakter'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          const Text("Konfirmasi Password",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: 'Ulangi password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                              ),
                            ),
                            validator: (v) => v!.isEmpty
                                ? 'Konfirmasi password tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _handleRegister,
                                  child: const Text('Daftar'),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          children: [
                            const TextSpan(text: 'Sudah punya akun? '),
                            TextSpan(
                              text: 'Masuk di sini',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white.withAlpha(128)),
                            )
                          ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
