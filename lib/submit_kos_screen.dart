import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models.dart';
import 'app_theme.dart';

class SubmitKosScreen extends StatefulWidget {
  const SubmitKosScreen({super.key});

  @override
  State<SubmitKosScreen> createState() => _SubmitKosScreenState();
}

class _SubmitKosScreenState extends State<SubmitKosScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final _submissionData = KosSubmission();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final ImagePicker _picker = ImagePicker();

  void _nextStep() {
    if (_currentStep == 2) {
      if (_submissionData.images.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Harap unggah minimal 3 foto.'),
              backgroundColor: Colors.red),
        );
        return;
      }
    } else if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) {
      return;
    }

    _formKeys[_currentStep].currentState?.save();

    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      context.go('/');
    }
  }

  Future<void> _submitForm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pengajuan'),
        content: const Text(
            'Apakah Anda yakin semua data yang dimasukkan sudah benar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Ya, Kirim')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.go('/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Pengajuan kos berhasil dikirim! Tim kami akan meninjau dalam 1-2 hari kerja.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles =
          await _picker.pickMultiImage(imageQuality: 80, limit: 10);
      if (!mounted) return;

      if (pickedFiles.isNotEmpty) {
        final totalImages = _submissionData.images.length + pickedFiles.length;
        if (totalImages > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Maksimal 10 foto.'),
                backgroundColor: Colors.red),
          );
          return;
        }

        setState(() {
          _submissionData.images.addAll(pickedFiles.map((f) => File(f.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Gagal mengambil gambar. Pastikan Anda memberikan izin akses galeri.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildStep2() {
    const allFacilities = [
      'WiFi',
      'AC',
      'Kamar Mandi Dalam',
      'Parkir',
      'Dapur Bersama',
      'Laundry',
      'Gym',
      'Kolam Renang',
      'Musholla',
      'Security 24 Jam'
    ];
    return Form(
      key: _formKeys[1],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Detail & Fasilitas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.description,
              decoration: const InputDecoration(
                  labelText: 'Deskripsi Kos',
                  hintText:
                      'Deskripsikan kos Anda, lokasi strategis, fasilitas unggulan, dll.'),
              maxLines: 4,
              onSaved: (v) => _submissionData.description = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 24),
          const Text("Fasilitas",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: allFacilities.map((facility) {
              final isSelected = _submissionData.facilities.contains(facility);
              return FilterChip(
                label: Text(facility),
                selected: isSelected,
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _submissionData.facilities.add(facility);
                  } else {
                    _submissionData.facilities.remove(facility);
                  }
                }),
                // FIX: Explicitly style the selected state for better visibility
                selectedColor: AppTheme.primaryColor,
                labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal),
                checkmarkColor: Colors.white,
                side: isSelected
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.shade300),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text("Peraturan Kos (Opsional)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.rules.join('\n'),
              decoration: const InputDecoration(
                  labelText: 'Peraturan',
                  hintText:
                      'Contoh:\n- Dilarang membawa hewan peliharaan\n- Jam malam pukul 22:00'),
              maxLines: 4,
              onSaved: (v) => _submissionData.rules =
                  v!.split('\n').where((s) => s.isNotEmpty).toList()),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Unggah Foto Kos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Minimal 3 foto, maksimal 10 foto. Ukuran maks 5MB per file.",
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 48, color: Colors.grey[700]),
                  const SizedBox(height: 8),
                  const Text("Klik untuk unggah foto"),
                  Text("PNG, JPG hingga 5MB",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_submissionData.images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _submissionData.images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_submissionData.images[index],
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _submissionData.images.removeAt(index)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(153),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    )
                  ],
                );
              },
            )
        ],
      ),
    );
  }

  // The rest of the file is unchanged
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
        title: const Text('Ajukan Kos'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(['Info Dasar', 'Detail', 'Foto', 'Kontak'][index],
                          style: TextStyle(
                            fontWeight: _currentStep >= index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _currentStep >= index
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          )),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: _currentStep >= index
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentStep = index),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4()
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        child: ElevatedButton(
          onPressed: _nextStep,
          child: Text(_currentStep == 3 ? 'Kirim Pengajuan' : 'Lanjutkan'),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Informasi Dasar Kos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.name,
              decoration: const InputDecoration(
                  labelText: 'Nama Kos',
                  hintText: 'Contoh: Kos Melati Residence'),
              onSaved: (v) => _submissionData.name = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.address,
              decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  hintText: 'Jl. Sudirman No. 123, Kelurahan, Kecamatan'),
              onSaved: (v) => _submissionData.address = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.city,
              decoration:
                  const InputDecoration(labelText: 'Kota', hintText: 'Jakarta'),
              onSaved: (v) => _submissionData.city = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.price,
              decoration: const InputDecoration(
                  labelText: 'Harga per Bulan (Rp)', hintText: '1500000'),
              keyboardType: TextInputType.number,
              onSaved: (v) => _submissionData.price = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          const Text("Jenis Kos", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'putra', label: Text('Putra'), icon: Icon(Icons.male)),
              ButtonSegment(
                  value: 'putri',
                  label: Text('Putri'),
                  icon: Icon(Icons.female)),
              ButtonSegment(
                  value: 'campur',
                  label: Text('Campur'),
                  icon: Icon(Icons.people)),
            ],
            selected: {_submissionData.type},
            onSelectionChanged: (Set<String> newSelection) =>
                setState(() => _submissionData.type = newSelection.first),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _formKeys[3],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Informasi Kontak",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.contactName,
              decoration:
                  const InputDecoration(labelText: 'Nama Pemilik/Pengelola'),
              onSaved: (v) => _submissionData.contactName = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.contactPhone,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
              onSaved: (v) => _submissionData.contactPhone = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              initialValue: _submissionData.contactEmail,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (v) => _submissionData.contactEmail = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Informasi Penting",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade900)),
                const SizedBox(height: 8),
                Text("• Tim kami akan meninjau pengajuan dalam 1-2 hari kerja",
                    style: TextStyle(color: Colors.yellow.shade800)),
                Text("• Kami akan menghubungi Anda untuk verifikasi data",
                    style: TextStyle(color: Colors.yellow.shade800)),
                Text("• Pastikan semua informasi yang diberikan akurat",
                    style: TextStyle(color: Colors.yellow.shade800)),
                Text("• Foto yang diunggah akan ditampilkan di aplikasi",
                    style: TextStyle(color: Colors.yellow.shade800)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
