import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Adam Biamantara',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('+621237-234-235')),
            const Center(child: Text('hima12345@gmail.com')),
            const SizedBox(height: 32),

            // Menu Profil
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Akun Saya'),
              onTap: () {
                // Navigate to account settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Nomor Telepon'),
              onTap: () {
                // Navigate to phone settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Ganti Password'),
              onTap: () {
                // Navigate to change password
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Implement logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
