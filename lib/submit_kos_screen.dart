// lib/submit_kos_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models.dart'; // Pastikan KosSubmission di sini sudah menggunakan List<Uint8List> imageBytes
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
    GlobalKey<FormState>(), // For Step 0: Info Dasar
    GlobalKey<FormState>(), // For Step 1: Detail & Fasilitas
    GlobalKey<FormState>(), // For Step 2: Unggah Foto Kos
    GlobalKey<FormState>() // For Step 3: Informasi Kontak
  ];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    bool isValid = true;

    // Validasi langkah saat ini
    if (_currentStep == 0 || _currentStep == 1 || _currentStep == 3) {
      isValid = _formKeys[_currentStep].currentState?.validate() ?? false;
      if (isValid) {
        _formKeys[_currentStep].currentState?.save();
      }
    } else if (_currentStep == 2) {
      // FIX: Hapus atau komentari bagian ini untuk menghilangkan batasan minimal foto.
      // if (_submissionData.imageBytes.isEmpty) {
      //   isValid = false;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //         content: Text('Harap unggah minimal 1 foto.'),
      //         backgroundColor: Colors.red),
      //   );
      // }
      // Jika tidak ada validasi khusus, maka langkah ini dianggap valid secara default.
      // Pastikan formKey[2] ada dan Form widget membungkus _buildStep3().
      isValid = true; // Atau bisa juga tambahkan validasi lain jika diperlukan
    }

    if (!isValid) {
      debugPrint('Validation failed for step $_currentStep');
      return; // Jangan lanjutkan jika validasi gagal
    }

    if (_currentStep < 3) {
      debugPrint('Moving to next step: ${_currentStep + 1}');
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      )
          .then((_) {
        // Setelah animasi selesai, pastikan state _currentStep diperbarui
        if (mounted) {
          setState(() {
            _currentStep = _pageController.page!.round();
          });
        }
      });
    } else {
      debugPrint('Attempting to submit form.');
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      debugPrint('Moving to previous step: ${_currentStep - 1}');
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      )
          .then((_) {
        if (mounted) {
          setState(() {
            _currentStep = _pageController.page!.round();
          });
        }
      });
    } else {
      debugPrint('Navigating back to home screen.');
      context.go('/'); // Kembali ke beranda jika di langkah pertama
    }
  }

  // Fungsi untuk mengunggah semua byte gambar dan mendapatkan URL-nya
  Future<List<String>> _uploadFiles(List<Uint8List> imageBytesList) async {
    List<String> imageUrls = [];
    // HANYA AKAN MENGUNGGAH JIKA ADA GAMBAR YANG DIPILIH
    if (imageBytesList.isEmpty) {
      debugPrint('No images to upload. Skipping Firebase Storage.');
      return []; // Kembalikan list kosong jika tidak ada gambar
    }

    final storageRef = FirebaseStorage.instance.ref().child('kos_images');
    debugPrint('Starting image upload for ${imageBytesList.length} images.');

    for (int i = 0; i < imageBytesList.length; i++) {
      Uint8List imageBytes = imageBytesList[i];
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      Reference fileRef = storageRef.child(fileName);

      debugPrint('Uploading image $i: $fileName');
      try {
        UploadTask uploadTask = fileRef.putData(imageBytes);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          debugPrint(
              'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        });

        TaskSnapshot snapshot = await uploadTask;
        debugPrint('Image $i uploaded. Getting download URL.');

        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
        debugPrint('Download URL for image $i: $downloadUrl');
      } on FirebaseException catch (e) {
        debugPrint(
            'Firebase Storage Error (Image $i): ${e.code} - ${e.message}');
        rethrow;
      } catch (e) {
        debugPrint('General Storage Error (Image $i): $e');
        rethrow;
      }
    }
    debugPrint('All images uploaded successfully.');
    return imageUrls;
  }

  Future<void> _submitForm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pengajuan'),
        content: const Text('Data akan disimpan ke database. Lanjutkan?'),
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
      setState(() => _isSubmitting = true); // Mulai loading
      debugPrint('Confirmation received. isSubmitting set to true.');

      try {
        debugPrint('Attempting to upload images (if any)...');
        // Hanya panggil _uploadFiles jika ada gambar yang dipilih
        List<String> imageUrls = [];
        if (_submissionData.imageBytes.isNotEmpty) {
          imageUrls = await _uploadFiles(_submissionData.imageBytes);
        } else {
          debugPrint('No images selected. Skipping image upload.');
        }

        debugPrint('Image handling complete. Proceeding to Firestore.');

        final dataToSave = {
          'namaKos': _submissionData.name,
          'alamat': _submissionData.address,
          'kota': _submissionData.city,
          'tipe': _submissionData.type,
          'harga': _submissionData.price,
          'deskripsi': _submissionData.description,
          'fasilitas': _submissionData.facilities,
          'peraturan': _submissionData.rules,
          'kontak_nama': _submissionData.contactName,
          'kontak_telepon': _submissionData.contactPhone,
          'kontak_email': _submissionData.contactEmail,
          'imageUrls':
              imageUrls, // Akan menjadi list kosong jika tidak ada gambar diunggah
          'status': 'pending',
          'waktuPengajuan': FieldValue.serverTimestamp(),
        };

        debugPrint('Saving data to Firestore...');
        await FirebaseFirestore.instance
            .collection('submissions')
            .add(dataToSave);
        debugPrint('Data successfully saved to Firestore.');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pengajuan kos berhasil disimpan!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/');
        }
      } on FirebaseException catch (e) {
        String userFacingMessage;
        if (e.code == 'permission-denied') {
          userFacingMessage =
              'Akses ditolak. Periksa aturan keamanan Firebase Anda.';
        } else if (e.code == 'unavailable') {
          userFacingMessage =
              'Koneksi ke server Firebase terputus atau tidak stabil. Coba lagi.';
        } else if (e.code.startsWith('storage/')) {
          // Menangkap error Storage secara umum
          userFacingMessage =
              'Gagal mengunggah gambar. Periksa aturan keamanan Storage Anda atau status login.';
        } else if (e.code == 'quota-exceeded') {
          userFacingMessage =
              'Kuota Firebase Anda habis. Hubungi administrator.';
        } else {
          userFacingMessage =
              'Terjadi kesalahan Firebase: ${e.message ?? e.code}';
        }
        debugPrint(
            'Firebase Error (SubmitKosScreen): ${e.code} - ${e.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userFacingMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        debugPrint('General Error (SubmitKosScreen): $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan pengajuan. Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
          debugPrint('isSubmitting set to false.');
        }
      }
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles =
          await _picker.pickMultiImage(imageQuality: 80, limit: 10);
      if (!mounted) return;

      if (pickedFiles.isNotEmpty) {
        if ((_submissionData.imageBytes.length + pickedFiles.length) > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Maksimal 10 foto.'),
                backgroundColor: Colors.red),
          );
          return;
        }
        for (XFile pickedFile in pickedFiles) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _submissionData.imageBytes.add(bytes);
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal memilih gambar: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

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
                          borderRadius: BorderRadius.circular(2),
                        ),
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
          onPressed: _isSubmitting ? null : _nextStep,
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
              : Text(_currentStep == 3 ? 'Kirim Pengajuan' : 'Lanjutkan'),
        ),
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
          // FIX: Perbarui teks petunjuk untuk mencerminkan tidak ada minimal foto
          Text(
              "Maksimal 10 foto. Foto pertama akan menjadi sampul (unggah opsional).",
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_submissionData.imageBytes.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _submissionData.imageBytes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(_submissionData.imageBytes[index],
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _submissionData.imageBytes.removeAt(index)),
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
        ],
      ),
    );
  }
}

