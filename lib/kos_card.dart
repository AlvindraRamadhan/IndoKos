import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class KosCard extends StatelessWidget {
  final KosData kos;
  final VoidCallback onWishlist;

  const KosCard({super.key, required this.kos, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/kos/${kos.id}'),
      child: Card(
        elevation: 1,
        shadowColor: Colors.black.withAlpha(26),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: kos.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: Icon(
                      kos.isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: kos.isWishlisted ? Colors.red : Colors.white,
                    ),
                    onPressed: onWishlist,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withAlpha(102),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(kos.address,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis))
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.star,
                            color: AppTheme.primaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(kos.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ]),
                      Text('${kos.reviewCount} ulasan',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatCurrency(kos.price),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor)),
                      const Text('/bulan',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
