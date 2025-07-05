import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // PERBAIKAN: Mengubah onPressed agar navigasi ke halaman '/profile'
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.go('/profile'), // Mengarahkan ke halaman profil
        ),
        title: const Text('Tentang Kami'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shadowColor: Colors.black.withAlpha(26),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(Icons.home_work_rounded,
                      size: 64, color: AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Text("IndoKos",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Cari Kos Impian Anda",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: "Misi Kami",
            icon: Icons.rocket_launch_outlined,
            content:
                "IndoKos adalah platform terdepan untuk mencari dan memesan kos di seluruh Indonesia. Kami berkomitmen untuk memberikan kemudahan, keamanan, dan kenyamanan bagi para pencari kos dan juga pemilik kos.",
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Theme.of(context).inputDecorationTheme.fillColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fitur Utama",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildFeatureTile(Icons.search_sharp, "Pencarian Cerdas",
                      "Filter lengkap untuk hasil akurat."),
                  _buildFeatureTile(
                      Icons.verified_user_outlined,
                      "Pemesanan Aman",
                      "Transaksi terverifikasi dan terjamin."),
                  _buildFeatureTile(Icons.payment_rounded, "Pembayaran Mudah",
                      "Beragam metode pembayaran online."),
                  _buildFeatureTile(Icons.add_business_outlined, "Ajukan Kos",
                      "Daftarkan properti Anda dengan mudah."),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(context,
              title: "Hubungi Kami",
              icon: Icons.support_agent_rounded,
              contentWidget: const Column(
                children: [
                  ListTile(
                      leading: Icon(
                        Icons.phone_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text("0851-9810-9885")),
                  ListTile(
                      leading: Icon(Icons.email_outlined,
                          color: AppTheme.primaryColor),
                      title: Text("2300016035@webmail.uad.ac.id")),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required IconData icon,
      String? content,
      Widget? contentWidget}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).inputDecorationTheme.fillColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            if (content != null)
              Text(
                content,
                style: TextStyle(
                    color: Colors.grey[700], height: 1.5, fontSize: 15),
              ),
            if (contentWidget != null) contentWidget
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor.withAlpha(26),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
