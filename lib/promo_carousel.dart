import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'app_theme.dart';
import 'models.dart';

class PromoCarousel extends StatelessWidget {
  PromoCarousel({super.key});

  final List<PromoItem> _promoData = [
    PromoItem(
      id: '4', // Corresponds to Kos Dahlia Syariah
      title: 'Promo Kos Putri',
      subtitle: 'Khusus kos putri dengan fasilitas lengkap',
      image:
          'https://images.pexels.com/photos/1571468/pexels-photo-1571468.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    PromoItem(
      id: '1', // Corresponds to Kos Melati
      title: 'Weekend Special',
      subtitle: 'Booking weekend dapat cashback 100K',
      image:
          'https://images.pexels.com/photos/1571470/pexels-photo-1571470.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    PromoItem(
      id: '3', // Corresponds to Kos Anggrek Premium
      title: 'Flash Sale Kos Premium',
      subtitle: 'Diskon hingga 30% untuk kos di pusat kota',
      image:
          'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Swiper(
        itemCount: _promoData.length,
        autoplay: true,
        autoplayDelay: 5000,
        viewportFraction: 0.85,
        scale: 0.9,
        pagination: const SwiperPagination(
          margin: EdgeInsets.all(10.0),
          builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
            activeColor: AppTheme.primaryColor,
            size: 8.0,
            activeSize: 10.0,
          ),
        ),
        itemBuilder: (BuildContext context, int index) {
          final promo = _promoData[index];
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: promo.image,
                    fit: BoxFit.cover,
                    color: AppTheme.secondaryColor.withAlpha(128),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 5, color: Colors.black54)
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          shadows: [
                            Shadow(blurRadius: 5, color: Colors.black54)
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.go('/kos/${promo.id}'), // Navigate on press
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                        ),
                        child: const Text("Lihat Promo"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
