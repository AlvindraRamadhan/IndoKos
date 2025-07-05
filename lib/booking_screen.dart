import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class BookingScreen extends StatefulWidget {
  final String kosId;
  const BookingScreen({super.key, required this.kosId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  final _bookingData = BookingData();
  final _formKey = GlobalKey<FormState>();
  final int _kosPrice = 1500000;
  final int _adminFee = 50000;

  void _next() {
    bool isStepValid = true;
    if (_currentStep == 0) {
      if (_bookingData.checkInDate.isEmpty || _bookingData.duration <= 0) {
        isStepValid = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pilih tanggal dan durasi terlebih dahulu.'),
            backgroundColor: Colors.red));
      }
    } else if (_currentStep == 1) {
      isStepValid = _formKey.currentState!.validate();
      if (isStepValid) {
        _formKey.currentState!.save();
      }
    }

    if (isStepValid) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        final totalPrice = (_kosPrice * _bookingData.duration) + _adminFee;
        context.go('/payment/${widget.kosId}', extra: {
          'bookingData': _bookingData,
          'totalPrice': totalPrice,
        });
      }
    }
  }

  // FIX: This logic correctly goes back one step, or exits the booking screen
  // to the previous page (Kos Detail) if on the first step.
  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepsContent = [
      _buildStep1(),
      _buildStep2(),
      _buildStep3(),
    ];
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back),
        title: const Text('Pemesanan Kos'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                          [
                            'Tanggal & Durasi',
                            'Data Pribadi',
                            'Konfirmasi'
                          ][index],
                          style: TextStyle(
                            fontSize: 12,
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
          Expanded(child: stepsContent[_currentStep]),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        child: ElevatedButton(
          onPressed: _next,
          child: Text(_currentStep == 2 ? 'Lanjut ke Pembayaran' : 'Lanjutkan'),
        ),
      ),
    );
  }

  // ... rest of the file is unchanged ...
  Widget _buildStep1() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Pilih Tanggal & Durasi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Tanggal Check-in',
              prefixIcon: Icon(Icons.calendar_today_outlined)),
          readOnly: true,
          controller: TextEditingController(
              text: _bookingData.checkInDate.isEmpty
                  ? ''
                  : DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(DateTime.parse(_bookingData.checkInDate))),
          onTap: () async {
            final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                          primary: AppTheme.primaryColor),
                    ),
                    child: child!,
                  );
                });
            if (pickedDate != null) {
              setState(() => _bookingData.checkInDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate));
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _bookingData.duration,
          decoration: const InputDecoration(
              labelText: 'Durasi Sewa', prefixIcon: Icon(Icons.access_time)),
          items: [1, 2, 3, 6, 12]
              .map((bulan) =>
                  DropdownMenuItem(value: bulan, child: Text('$bulan bulan')))
              .toList(),
          onChanged: (value) => setState(() => _bookingData.duration = value!),
        ),
        const SizedBox(height: 24),
        _buildPriceSummary(),
      ],
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Data Pribadi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              onSaved: (v) => _bookingData.fullName = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
              onSaved: (v) => _bookingData.phone = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (v) => _bookingData.email = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Nomor KTP', hintText: '16 digit nomor KTP'),
              keyboardType: TextInputType.number,
              onSaved: (v) => _bookingData.idNumber = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
          const SizedBox(height: 16),
          TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Kontak Darurat',
                  hintText: 'Nomor telepon keluarga/teman'),
              keyboardType: TextInputType.phone,
              onSaved: (v) => _bookingData.emergencyContact = v!,
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Konfirmasi Pemesanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Catatan Tambahan (Opsional)',
              hintText: 'Permintaan khusus atau informasi tambahan...'),
          maxLines: 3,
          onChanged: (v) => _bookingData.additionalNotes = v,
        ),
        const SizedBox(height: 24),
        Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withAlpha(51)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ringkasan Pemesanan",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildSummaryRow("Nama", _bookingData.fullName),
                _buildSummaryRow(
                    "Check-in",
                    _bookingData.checkInDate.isEmpty
                        ? "-"
                        : DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(_bookingData.checkInDate))),
                _buildSummaryRow("Durasi", "${_bookingData.duration} bulan"),
                const Divider(height: 24),
                _buildSummaryRow(
                    "Total Pembayaran",
                    formatCurrency(
                        (_kosPrice * _bookingData.duration) + _adminFee),
                    isBold: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
              "Perhatian: Setelah melanjutkan ke pembayaran, Anda akan diarahkan ke halaman pembayaran yang aman. Pastikan data yang Anda masukkan sudah benar.",
              style: TextStyle(color: Colors.yellow.shade900, height: 1.5)),
        )
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Card(
      color: AppTheme.primaryColor.withAlpha(13),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow("Sewa ${_bookingData.duration} bulan",
                formatCurrency(_kosPrice * _bookingData.duration)),
            _buildSummaryRow("Biaya admin", formatCurrency(_adminFee)),
            const Divider(),
            _buildSummaryRow("Total",
                formatCurrency((_kosPrice * _bookingData.duration) + _adminFee),
                isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold
                  ? AppTheme.primaryColor
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
