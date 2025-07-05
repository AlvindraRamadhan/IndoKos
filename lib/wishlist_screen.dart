import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'kos_provider.dart';
import 'kos_card_mobile.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

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
        title: const Text('Wishlist'),
      ),
      body: Consumer<KosProvider>(
        builder: (context, provider, child) {
          final wishlistedItems = provider.wishlistedKos;
          if (wishlistedItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "Wishlist Anda Kosong",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mulai tambahkan kos favorit Anda!",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: wishlistedItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final kos = wishlistedItems[index];
              return KosCardMobile(
                kos: kos,
                onTap: () => context.go('/kos/${kos.id}'),
                onWishlist: () => provider.toggleWishlist(kos.id),
              );
            },
          );
        },
      ),
    );
  }
}
