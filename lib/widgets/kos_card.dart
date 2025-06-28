import 'package:flutter/material.dart';
import 'package:indokos/models/kos_model.dart';

class KosCard extends StatelessWidget {
  final Kos kos;
  final VoidCallback onTap;
  final Function(bool) onWishlistChanged;

  const KosCard({
    super.key,
    required this.kos,
    required this.onTap,
    required this.onWishlistChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kos.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      kos.isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: kos.isWishlisted ? Colors.red : null,
                    ),
                    onPressed: () {
                      onWishlistChanged(!kos.isWishlisted);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(kos.location),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text('${kos.rating} (${kos.reviewers} reviewers)'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} /${kos.type == 'bulanan' ? 'Bulan' : 'Tahun'}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF00B8A9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
