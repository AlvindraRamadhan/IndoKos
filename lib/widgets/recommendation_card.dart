import 'package:flutter/material.dart';
import 'package:indokos/models/kos_model.dart';
import 'package:indokos/screens/kos_detail_screen.dart';

class RecommendationCard extends StatelessWidget {
  final Kos kos;

  const RecommendationCard({super.key, required this.kos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KosDetailScreen(kos: kos),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      kos.images.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kos.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${kos.rating}'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(color: Color(0xFF00B8A9)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
