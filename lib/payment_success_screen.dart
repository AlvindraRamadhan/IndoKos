import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file_plus/open_file_plus.dart';
import 'dart:io';

import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> paymentDetails;
  const PaymentSuccessScreen({super.key, required this.paymentDetails});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  // FIX: Implemented PDF generation and download functionality
  Future<void> _downloadReceipt() async {
    final BookingData? bookingData = widget.paymentDetails['bookingData'];
    final Map<String, dynamic>? paymentMethod =
        widget.paymentDetails['paymentMethod'];
    final int? totalAmount = widget.paymentDetails['totalPrice'];
    final String bookingId =
        "IK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    if (bookingData == null || paymentMethod == null || totalAmount == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data tidak valid untuk membuat struk.')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Struk Pembayaran IndoKos',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 24)),
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('ID Pemesanan:'),
                    pw.Text(bookingId,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tanggal Transaksi:'),
                    pw.Text(DateFormat('d MMMM yyyy, HH:mm', 'id_ID')
                        .format(DateTime.now())),
                  ]),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Detail Pemesanan:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text(
                  'Nama Kos: Kos Melati Residence'), // Note: This is static data
              pw.Text('Nama Penyewa: ${bookingData.fullName}'),
              pw.Text(
                  'Check-in: ${DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(bookingData.checkInDate))}'),
              pw.Text('Durasi: ${bookingData.duration} bulan'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Detail Pembayaran:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Metode Pembayaran: ${paymentMethod['name']}'),
              pw.SizedBox(height: 20),
              pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                      borderRadius: pw.BorderRadius.circular(5)),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('TOTAL PEMBAYARAN',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        pw.Text(formatCurrency(totalAmount),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 18,
                                color: PdfColors.green)),
                      ])),
              pw.SizedBox(height: 40),
              pw.Center(
                  child: pw.Text(
                      '--- Terima Kasih Telah Menggunakan IndoKos ---',
                      style: const pw.TextStyle(color: PdfColors.grey))),
            ],
          );
        },
      ),
    );

    try {
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/struk_indokos_$bookingId.pdf");
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Struk disimpan di folder Dokumen.')));

      // Open the file
      await OpenFile.open(file.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan struk: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookingData? bookingData = widget.paymentDetails['bookingData'];
    final Map<String, dynamic>? paymentMethod =
        widget.paymentDetails['paymentMethod'];
    final int? totalAmount = widget.paymentDetails['totalPrice'];
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
            _buildDetailRow("Nama Kos", "Kos Melati Residence"),
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
                        onPressed: _downloadReceipt)),
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
