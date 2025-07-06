// lib/mobile_bottom_nav.dart

import 'package:flutter/material.dart';
import 'app_theme.dart';

class MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const MobileBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.chat_bubble_rounded, 'label': 'Chat'},
      {'icon': Icons.add_circle_rounded, 'label': 'Ajukan'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Riwayat'},
      {'icon': Icons.person_rounded, 'label': 'Profil'},
    ];
    return Container(
      height: 65 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // [cite: 221]
            blurRadius: 10,
          )
        ],
        border: Border(
            top: BorderSide(
                color: Colors.grey.withAlpha(51), width: 1)), // [cite: 529]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final bool isSelected = currentIndex == index;
          final bool isCenterButton = index == 2;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCenterButton)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: AppTheme.primaryGradient, // [cite: 532]
                        shape: BoxShape.circle, // [cite: 532]
                      ),
                      child: Icon(item['icon'] as IconData,
                          color: Colors.white, size: 30), // [cite: 533]
                    )
                  else
                    Icon(
                      item['icon'] as IconData, // [cite: 534]
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[500], //
                      size: 26,
                    ),

                  // FIX: Hapus SizedBox ini untuk menghilangkan overflow
                  // const SizedBox(height: 3),

                  Text(
                    item['label'] as String, // [cite: 536]
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected && !isCenterButton
                          ? AppTheme.primaryColor
                          : (isCenterButton
                              ? AppTheme.primaryColor
                              : Colors.grey[600]), // [cite: 537, 538]
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis, // Mencegah teks memanjang
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
