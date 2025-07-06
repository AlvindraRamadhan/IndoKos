// lib/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@indokos.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscureText = true;
  String _error = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await context.read<AuthProvider>().login(
            _emailController.text,
            _passwordController.text,
          );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await context.read<AuthProvider>().loginWithGoogle();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
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
                  const Icon(Icons.home_work_rounded,
                      size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text('IndoKos',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Masuk ke akun Anda',
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
                          const Text("Email",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: 'email@example.com',
                                prefixIcon: Icon(Icons.mail_outline)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                v!.isEmpty ? 'Email tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text("Password",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: 'password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setState(
                                    () => _obscureText = !_obscureText),
                              ),
                            ),
                            validator: (v) => v!.isEmpty
                                ? 'Password tidak boleh kosong'
                                : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () => context.go('/forgot-password'),
                                child: const Text('Lupa password?')),
                          ),
                          const SizedBox(height: 8),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _handleLogin,
                                  child: const Text('Masuk')),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("atau"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            icon: SvgPicture.string(
                                '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="20px" height="20px"><path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12s5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24s8.955,20,20,20s20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"/><path fill="#FF3D00" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"/><path fill="#4CAF50" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"/><path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.089,5.571l6.19,5.238C42.022,36.219,44,30.563,44,24C44,22.659,43.862,21.35,43.611,20.083z"/></svg>'),
                            label: const Text('Masuk dengan Google'),
                            onPressed: _isLoading ? null : _handleGoogleLogin,
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                side: BorderSide(color: Colors.grey.shade300)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Belum punya akun? '),
                        TextSpan(
                          text: 'Daftar sekarang',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Demo Login:\nEmail: demo@indokos.com\nPassword: password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
