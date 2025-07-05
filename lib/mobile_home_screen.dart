import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'kos_provider.dart';
import 'kos_card_mobile.dart';
import 'promo_carousel.dart';
import 'filter_modal.dart';
import 'app_theme.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  Widget _buildCategoryChip(
      String label, String type, int count, KosProvider provider) {
    final bool isActive = provider.selectedType == type;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isActive,
      onSelected: (selected) {
        if (selected) {
          provider.applyFilter(type: type, query: provider.searchQuery);
        }
      },
      backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isActive
            ? Colors.white
            : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      pressElevation: 0,
    );
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
    final kosProvider = Provider.of<KosProvider>(context);
    final allKos = kosProvider.allKos;
    final filteredKos = kosProvider.filteredKos;

    return Scaffold(
      appBar: AppBar(
        // FIX: Removed leadingWidth and used a flexible Row for the title
        titleSpacing: 16.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)),
              child: const Center(
                child: Text(
                  'IK',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'IndoKos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              backgroundColor: Colors.red,
              label: Text('2'),
              child: Icon(Icons.notifications_none_outlined),
            ),
            onPressed: () => context.go('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          PromoCarousel(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.go('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withAlpha(51)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Text('Cari kos di sekitar Anda...',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded,
                      color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () => _showFilter(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "Kos Terbaik",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('Semua', 'all', allKos.length, kosProvider),
                const SizedBox(width: 8),
                _buildCategoryChip('Putra', 'putra',
                    allKos.where((k) => k.type == 'putra').length, kosProvider),
                const SizedBox(width: 8),
                _buildCategoryChip('Putri', 'putri',
                    allKos.where((k) => k.type == 'putri').length, kosProvider),
                const SizedBox(width: 8),
                _buildCategoryChip(
                    'Campur',
                    'campur',
                    allKos.where((k) => k.type == 'campur').length,
                    kosProvider),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Ditemukan ${filteredKos.length} kos",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          if (filteredKos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      "Tidak ada kos ditemukan",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Coba ubah filter pencarian Anda",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: filteredKos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final kos = filteredKos[index];
                return KosCardMobile(
                  kos: kos,
                  onTap: () => context.go('/kos/${kos.id}'),
                  onWishlist: () => kosProvider.toggleWishlist(kos.id),
                );
              },
            ),
        ],
      ),
    );
  }
}
