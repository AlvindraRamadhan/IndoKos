import 'package:flutter/material.dart';
import 'package:indokos/models/kos_model.dart';
import 'package:indokos/screens/booking_confirmation_screen.dart';
import 'package:indokos/widgets/facility_chip.dart';

class KosDetailScreen extends StatefulWidget {
  final Kos kos;

  const KosDetailScreen({super.key, required this.kos});

  @override
  State<KosDetailScreen> createState() => _KosDetailScreenState();
}

class _KosDetailScreenState extends State<KosDetailScreen> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    isWishlisted = widget.kos.isWishlisted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isWishlisted = !isWishlisted;
                widget.kos.isWishlisted = isWishlisted;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: widget.kos.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.kos.images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.kos.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.kos.location,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                          '${widget.kos.rating} (${widget.kos.reviewers} reviewers)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rp ${widget.kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B8A9)),
                  ),
                  const Text('/Perbulan'),
                  const SizedBox(height: 24),
                  const Text('Fasilitas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.kos.facilities
                        .map((facility) => FacilityChip(facility: facility))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Peraturan Property',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      '1. Seluruh fasilitas kost, hanya diperuntukkan bagi Penyewa kost/penyewa kamar, bukan untuk umum'),
                  const SizedBox(height: 8),
                  const Text(
                      '2. Penyewa kost dilarang menerima tamu dan/atau membawa teman ke kamar kost. Sebaiknya menerima tamu atau teman adalah di tempat terbuka atau tempat umum lainnya, seperti warung atau cafe/resto.'),
                  const SizedBox(height: 8),
                  const Text(
                      '3. Penyewa kost tidak diperkenankan merokok di dalam kamar maupun di lingkungan rumah kost.'),
                  const SizedBox(height: 24),
                  const Text('Deskripsi Property',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.kos.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B8A9),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BookingConfirmationScreen(kos: widget.kos),
              ),
            );
          },
          child: const Text('Pesan Kost',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
