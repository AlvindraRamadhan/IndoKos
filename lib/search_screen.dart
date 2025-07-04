import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'kos_provider.dart';
import 'kos_card_mobile.dart';
import 'models.dart'; // Import ini diperlukan
import 'filter_modal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilter(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KosProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pencarian Kos'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<KosProvider>(
                      builder: (context, provider, child) {
                        return TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: (value) =>
                              provider.filterKos(value, provider.selectedType),
                          decoration: const InputDecoration(
                            hintText: 'Cari nama kos atau lokasi...',
                            prefixIcon: Icon(Icons.search),
                          ),
                        );
                      },
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
          ),
        ),
        body: Consumer<KosProvider>(
          builder: (context, provider, child) {
            final kosList = provider.filteredKos;
            if (kosList.isEmpty && _searchController.text.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text("Kos tidak ditemukan",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Coba ubah kata kunci pencarian Anda.",
                        style: TextStyle(color: Colors.grey[600])),
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
    );
  }
}
