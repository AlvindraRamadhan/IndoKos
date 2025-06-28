import 'package:flutter/material.dart';

class SubmitKosScreen extends StatefulWidget {
  const SubmitKosScreen({super.key});

  @override
  State<SubmitKosScreen> createState() => _SubmitKosScreenState();
}

class _SubmitKosScreenState extends State<SubmitKosScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _facilities = [];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Kos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Isi informasi Kos untuk calon penyewa',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Nama Kos
            const Text(
              'Nama Kos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Kos Mawar Indah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Lokasi
            const Text('Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Contoh: jl.Merdeka No.10',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Harga
            const Text(
              'Harga Per Bulan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Contoh: 1500000',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Fasilitas
            const Text(
              'Fasilitas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                CheckboxListTile(
                  title: const Text('KM Dalam'),
                  value: _facilities.contains('KM Dalam'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('KM Dalam');
                      } else {
                        _facilities.remove('KM Dalam');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('AC'),
                  value: _facilities.contains('AC'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('AC');
                      } else {
                        _facilities.remove('AC');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Wifi'),
                  value: _facilities.contains('Wifi'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('Wifi');
                      } else {
                        _facilities.remove('Wifi');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Parkir'),
                  value: _facilities.contains('Parkir'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('Parkir');
                      } else {
                        _facilities.remove('Parkir');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Dapur'),
                  value: _facilities.contains('Dapur'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('Dapur');
                      } else {
                        _facilities.remove('Dapur');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Laundry'),
                  value: _facilities.contains('Laundry'),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _facilities.add('Laundry');
                      } else {
                        _facilities.remove('Laundry');
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Kos anda',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Foto
            const Text(
              'Foto Kos (max 5)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Implement photo upload
              },
              child: const Text('+ Upload Foto'),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B8A9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Implement submit logic
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ajukan Sekarang',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
