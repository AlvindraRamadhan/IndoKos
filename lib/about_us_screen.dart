import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskripsi",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "IndoKos adalah platform terdepan untuk mencari dan memesan kos di seluruh Indonesia. Kami berkomitmen untuk memberikan kemudahan, keamanan, dan kenyamanan bagi para pencari kos dan juga pemilik kos.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
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
                  const SizedBox(height: 8),
                  const ListTile(
                      leading: Icon(Icons.search),
                      title: Text("Pencarian Cerdas & Filter Lengkap")),
                  const ListTile(
                      leading: Icon(Icons.verified_user_outlined),
                      title: Text("Pemesanan Aman & Terverifikasi")),
                  const ListTile(
                      leading: Icon(Icons.payment),
                      title: Text("Beragam Metode Pembayaran")),
                  const ListTile(
                      leading: Icon(Icons.add_business_outlined),
                      title: Text("Kemudahan Ajukan Kos bagi Pemilik")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Informasi Lebih Lanjut",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const ListTile(
                      leading: Icon(Icons.phone_outlined),
                      title: Text("0851-9810-9885")),
                  const ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text("2300016035@webmail.uad.ac.id")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
