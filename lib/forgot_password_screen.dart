// lib/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
      _isError = false;
    });

    try {
      await context
          .read<AuthProvider>()
          .sendPasswordResetEmail(_emailController.text);
      if (mounted) {
        setState(() {
          _message =
              'Link reset password telah dikirim. Silakan periksa kotak masuk (dan folder spam) email Anda.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = e.toString().replaceFirst('Exception: ', '');
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.lock_reset_rounded,
                      size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text('Lupa Password',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Masukkan email Anda untuk reset password',
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
                          const Text("Email Terdaftar",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: 'email@example.com',
                                prefixIcon: Icon(Icons.mail_outline)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || !v.contains('@')) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _sendResetLink,
                                  child: const Text('Kirim Link Reset')),
                          if (_message.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              _message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: _isError
                                      ? Colors.red
                                      : Colors.green.shade700),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: const Text.rich(
                      TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(text: 'Kembali ke halaman '),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
