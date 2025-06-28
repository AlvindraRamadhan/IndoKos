import 'package:flutter/material.dart';
import 'package:indokos/utils/mock_data.dart';
import 'package:indokos/widgets/kos_card.dart';
import 'package:indokos/screens/kos_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistedKos = mockKosList.where((kos) => kos.isWishlisted).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChip(
                  label: const Text('Termurah'),
                  onSelected: (value) {
                    setState(() {
                      wishlistedKos.sort((a, b) => a.price.compareTo(b.price));
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Termahal'),
                  onSelected: (value) {
                    setState(() {
                      wishlistedKos.sort((a, b) => b.price.compareTo(a.price));
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Terbersih'),
                  onSelected: (value) {
                    setState(() {
                      wishlistedKos.sort((a, b) {
                        final aClean = a.facilities.contains('KM Dalam')
                            ? 1
                            : 0;
                        final bClean = b.facilities.contains('KM Dalam')
                            ? 1
                            : 0;
                        return bClean.compareTo(aClean);
                      });
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Rating'),
                  onSelected: (value) {
                    setState(() {
                      wishlistedKos.sort(
                        (a, b) => b.rating.compareTo(a.rating),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistedKos.length,
              itemBuilder: (context, index) {
                final kos = wishlistedKos[index];
                return KosCard(
                  kos: kos,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KosDetailScreen(kos: kos),
                      ),
                    );
                  },
                  onWishlistChanged: (isWishlisted) {
                    setState(() {
                      kos.isWishlisted = isWishlisted;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
