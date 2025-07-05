import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'auth_provider.dart';
import 'app_theme.dart';
import 'models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        // FIX: Cukup panggil logout(). Navigasi akan ditangani secara
        // otomatis oleh AppRouter yang sudah diperbaiki.
        context.read<AuthProvider>().logout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileHeader(context, user),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildInfoSection(context, user),
            const SizedBox(height: 24),
            _buildLogoutButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00B8A9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white.withAlpha(230),
            child: user.avatar != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.avatar!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 35,
                          color: AppTheme.primaryColor),
                    ),
                  )
                : const Icon(Icons.person,
                    size: 35, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                      fontSize: 14, color: Colors.white.withAlpha(217)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.provider == 'google'
                        ? 'Google Account'
                        : 'Email Account',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return _buildCard(
      context: context,
      title: "Aksi Cepat",
      children: [
        ListTile(
          leading: const Icon(Icons.favorite_border_rounded,
              color: AppTheme.primaryColor),
          title: const Text('Wishlist'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/wishlist'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded,
              color: AppTheme.primaryColor),
          title: const Text('Tentang Kami'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/about-us'),
        ),
        ListTile(
          leading:
              const Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
          title: const Text('Pengaturan'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/settings'),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, UserModel user) {
    return _buildCard(
      context: context,
      title: "Informasi Profil",
      children: [
        _buildInfoRow(Icons.person_outline, "Nama Lengkap", user.name),
        _buildInfoRow(Icons.mail_outline, "Email", user.email),
        _buildInfoRow(Icons.calendar_today_outlined, "Bergabung", "Juli 2025"),
      ],
    );
  }

  Widget _buildCard(
      {required BuildContext context,
      required String title,
      required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).inputDecorationTheme.fillColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(icon, size: 20, color: Colors.grey[600]),
      title: Text(label, style: TextStyle(color: Colors.grey[700])),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.red.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Keluar',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        onTap: () => _showLogoutConfirmation(context),
      ),
    );
  }
}
