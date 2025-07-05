import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // PERBAIKAN: Mengubah onPressed agar navigasi ke halaman '/profile'
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.go('/profile'), // Mengarahkan ke halaman profil
        ),
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsCard(context: context, title: "Tampilan", children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: const Text("Dark Mode"),
              subtitle: Text(themeProvider.isDarkMode ? "Aktif" : "Nonaktif"),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: AppTheme.primaryColor,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSettingsCard(context: context, title: "Akun", children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profil'),
              trailing: const Icon(Icons.chevron_right),
              // FIX: Navigate to the new edit profile screen
              onTap: () => context.push('/edit-profile'),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ubah Password'),
              trailing: const Icon(Icons.chevron_right),
              // FIX: Navigate to the new change password screen
              onTap: () => context.push('/change-password'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
      {required BuildContext context,
      required String title,
      required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).inputDecorationTheme.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
