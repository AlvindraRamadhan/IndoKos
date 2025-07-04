import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'kos_provider.dart';
import 'models.dart';
import 'app_theme.dart';
import 'utils.dart';

class KosDetailScreen extends StatelessWidget {
  final String kosId;
  const KosDetailScreen({super.key, required this.kosId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KosProvider(),
      child: Consumer<KosProvider>(
        builder: (context, provider, child) {
          final kos = provider.findById(kosId);
          // Mock owner data
          final owner = {'phone': '+6281234567890'};

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  floating: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildImageGallery(kos),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                          kos.isWishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: Colors.white),
                      onPressed: () => provider.toggleWishlist(kos.id),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.share_rounded, color: Colors.white),
                      onPressed: () {/* Share logic */},
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBasicInfo(context, kos),
                    _buildSection(
                      "Deskripsi",
                      Text(
                        "Kos nyaman dan strategis di pusat kota Jakarta. Dilengkapi dengan fasilitas lengkap dan keamanan 24 jam. Cocok untuk mahasiswa dan pekerja muda.",
                        style: TextStyle(color: Colors.grey[700], height: 1.5),
                      ),
                    ),
                    _buildFacilities(kos.facilities),
                    const SizedBox(height: 100), // Spacer for bottom bar
                  ]),
                ),
              ],
            ),
            bottomNavigationBar:
                _buildBottomBar(context, kosId, owner['phone']!),
          );
        },
      ),
    );
  }

  Widget _buildImageGallery(KosData kos) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: kos.image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[300]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withAlpha(102),
                Colors.transparent
              ], // Diperbaiki
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(128), // Diperbaiki
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("1 / 4", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context, KosData kos) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(kos.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Text(
                formatCurrency(kos.price), // 'const' dihapus dari sini
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor),
              ),
            ],
          ),
          const Text("/bulan", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(kos.address,
                      style: TextStyle(color: Colors.grey[700]))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Text('${kos.rating} (${kos.reviewCount} ulasan)'),
              const Spacer(),
              Text('${kos.distance} dari sini',
                  style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip("Kamar Tersedia", "3 Kamar"),
              _buildInfoChip("Ukuran Kamar", "4x4 m"),
              _buildInfoChip(
                  "Tipe", kos.type[0].toUpperCase() + kos.type.substring(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          content,
          const Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Divider(height: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilities(List<String> facilities) {
    return _buildSection(
      "Fasilitas",
      Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: facilities
            .map((f) => Chip(
                  label: Text(f),
                  backgroundColor:
                      AppTheme.primaryColor.withAlpha(26), // Diperbaiki
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  side: BorderSide.none,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, String kosId, String ownerPhone) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ], // Diperbaiki
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final url = Uri.parse("tel:$ownerPhone");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: const Text("Hubungi"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.go('/booking/$kosId'),
              child: const Text("Pesan Sekarang"),
            ),
          ),
        ],
      ),
    );
  }
}
