import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'kos_provider.dart';
import 'kos_card_mobile.dart';
import 'models.dart';
import 'filter_modal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sync the controller with the provider's state when the screen loads
    _searchController.text =
        Provider.of<KosProvider>(context, listen: false).searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilter(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Kos'),
        // PERBAIKAN: Menambahkan leading back button untuk navigasi ke dashboard utama
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.go('/'), // Mengarahkan ke root path (dashboard utama)
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (value) => provider.applyFilter(query: value),
                    decoration: const InputDecoration(
                      hintText: 'Cari nama kos atau lokasi...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilter(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<KosProvider>(
              builder: (context, provider, child) {
                final kosList = provider.filteredKos;
                if (kosList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          "Kos tidak ditemukan",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Coba ubah kata kunci atau filter pencarian Anda.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: kosList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final kos = kosList[index];
                    return KosCardMobile(
                      kos: kos,
                      onTap: () => context.go('/kos/${kos.id}'),
                      onWishlist: () => provider.toggleWishlist(kos.id),
                    );
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
