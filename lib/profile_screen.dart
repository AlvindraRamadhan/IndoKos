import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'auth_provider.dart';
import 'app_theme.dart';
import 'models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Center(child: Text("Pengguna tidak ditemukan."));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProfileHeader(context, user),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildInfoSection(user),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(51)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryColor.withAlpha(26),
            child: user.avatar != null
                ? ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: user.avatar!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover))
                : const Icon(Icons.person,
                    size: 40, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 12),
          Text(user.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(user.email,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
                user.provider == 'google' ? 'Google Account' : 'Email Account',
                style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text("Aksi Cepat",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
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
              leading: const Icon(Icons.settings_outlined,
                  color: AppTheme.primaryColor),
              title: const Text('Pengaturan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informasi Profil",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person_outline, "Nama Lengkap", user.name),
            _buildInfoRow(Icons.mail_outline, "Email", user.email),
            _buildInfoRow(Icons.calendar_today_outlined, "Bergabung",
                "Juli 2025"), // Data statis
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: Colors.grey[600]),
      title: Text(label, style: TextStyle(color: Colors.grey[700])),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: Colors.red.withAlpha(26),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Keluar',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        onTap: () => context.read<AuthProvider>().logout(),
      ),
    );
  }
}
