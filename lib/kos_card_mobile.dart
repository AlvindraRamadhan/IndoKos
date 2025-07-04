import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class KosCardMobile extends StatelessWidget {
  final KosData kos;
  final VoidCallback onTap;
  final VoidCallback onWishlist;

  const KosCardMobile(
      {super.key,
      required this.kos,
      required this.onTap,
      required this.onWishlist});

  Color _getTypeBgColor(String type) {
    switch (type) {
      case 'putra':
        return Colors.blue.shade50;
      case 'putri':
        return Colors.pink.shade50;
      case 'campur':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'putra':
        return Colors.blue.shade700;
      case 'putri':
        return Colors.pink.shade700;
      case 'campur':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0x33BEBEBE)), // Change this line
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(10, 0, 0, 0), // Change this line
                blurRadius: 8,
                offset: Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                    imageUrl: kos.image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200])),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: _getTypeBgColor(kos.type),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                        kos.type[0].toUpperCase() + kos.type.substring(1),
                        style: TextStyle(
                            color: _getTypeTextColor(kos.type),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color:
                              Colors.white.withAlpha(229), // Change this line
                          shape: BoxShape.circle),
                      child: Icon(
                        kos.isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: kos.isWishlisted
                            ? Colors.red
                            : Colors.grey.shade600,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color:
                              Colors.black.withAlpha(128), // Change this line
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text('${kos.rating} (${kos.reviewCount})',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kos.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_on_outlined,
                        size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(kos.address,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis))
                  ]),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatCurrency(kos.price),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.primaryColor)),
                          Text('/bulan',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        child: const Text('Detail'),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
