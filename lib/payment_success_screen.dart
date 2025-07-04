import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> paymentDetails;
  const PaymentSuccessScreen({super.key, required this.paymentDetails});
  @override
  Widget build(BuildContext context) {
    final BookingData? bookingData = paymentDetails['bookingData'];
    final Map<String, dynamic>? paymentMethod = paymentDetails['paymentMethod'];
    final int? totalAmount = paymentDetails['totalPrice'];
    final String bookingId =
        "IK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";
    if (bookingData == null || paymentMethod == null || totalAmount == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text("Data pembayaran tidak valid.")));
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSuccessHeader(bookingId),
          const SizedBox(height: 24),
          _buildDetailCard("Detail Kos", [
            _buildDetailRow("Nama Kos",
                "Kos Melati Residence"), // Static based on mock data
            _buildDetailRow(
                "Check-in",
                DateFormat.yMMMMd('id_ID')
                    .format(DateTime.parse(bookingData.checkInDate))),
            _buildDetailRow("Durasi", "${bookingData.duration} bulan"),
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("Informasi Pembayaran", [
            _buildDetailRow(
                "Metode Pembayaran", paymentMethod['name'] as String),
            _buildDetailRow("Total Dibayar", formatCurrency(totalAmount),
                valueColor: Colors.green, isBold: true),
            _buildDetailRow("Status", "Berhasil", valueColor: Colors.green),
            _buildDetailRow("Waktu Pembayaran",
                DateFormat('d/M/y, HH:mm:ss').format(DateTime.now())),
          ]),
          const SizedBox(height: 16),
          _buildDetailCard("Informasi Penyewa", [
            _buildDetailRow("Nama", bookingData.fullName),
            _buildDetailRow("Telepon", bookingData.phone),
            _buildDetailRow("Email", bookingData.email),
          ]),
          const SizedBox(height: 24),
          Card(
            color: AppTheme.primaryColor.withAlpha(26),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Langkah Selanjutnya",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("• Pemilik kos akan menghubungi Anda dalam 1x24 jam",
                      style: TextStyle(color: Colors.grey[700])),
                  Text("• Siapkan dokumen identitas untuk proses check-in",
                      style: TextStyle(color: Colors.grey[700])),
                  Text("• Datang sesuai tanggal check-in yang telah ditentukan",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: OutlinedButton.icon(
                        icon: const Icon(Icons.download_outlined),
                        label: const Text("Download"),
                        onPressed: () {})),
                const SizedBox(width: 16),
                Expanded(
                    child: OutlinedButton.icon(
                        icon: const Icon(Icons.share_outlined),
                        label: const Text("Bagikan"),
                        onPressed: () {})),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: const Text("Kembali ke Beranda"),
                onPressed: () => context.go('/'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(String bookingId) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration:
              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16),
        const Text("Pembayaran Berhasil!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
            "Pemesanan kos Anda telah dikonfirmasi dan pembayaran berhasil diproses.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 16),
        Text("ID Pemesanan", style: TextStyle(color: Colors.grey[600])),
        Text(bookingId,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor)),
        Text("Simpan ID ini untuk referensi Anda",
            style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }
}
