import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  const PaymentScreen({super.key, required this.bookingDetails});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;
  bool _isProcessing = false;

  final paymentMethods = [
    {
      'group': 'Transfer Bank',
      'methods': [
        {
          'id': 'bca',
          'name': 'BCA Virtual Account',
          'icon': Icons.account_balance,
          'fee': 4000
        },
        {
          'id': 'mandiri',
          'name': 'Mandiri Virtual Account',
          'icon': Icons.account_balance,
          'fee': 4000
        },
        {
          'id': 'bni',
          'name': 'BNI Virtual Account',
          'icon': Icons.account_balance,
          'fee': 4000
        },
      ]
    },
    {
      'group': 'E-Wallet',
      'methods': [
        {'id': 'gopay', 'name': 'GoPay', 'icon': Icons.wallet, 'fee': 0},
        {'id': 'ovo', 'name': 'OVO', 'icon': Icons.wallet, 'fee': 0},
        {'id': 'dana', 'name': 'DANA', 'icon': Icons.wallet, 'fee': 0},
      ]
    },
  ];

  void _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final selectedPaymentDetails = paymentMethods
          .expand((group) => group['methods'] as List)
          .firstWhere((method) => method['id'] == _selectedMethod);

      context.go('/payment-success', extra: {
        ...widget.bookingDetails,
        'paymentMethod': selectedPaymentDetails,
      });
    }
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final BookingData? bookingData = widget.bookingDetails['bookingData'];
    final int? totalPrice = widget.bookingDetails['totalPrice'];
    if (bookingData == null || totalPrice == null) {
      return const Scaffold(
          body: Center(child: Text("Data pemesanan tidak valid.")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppTheme.primaryColor.withAlpha(13),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ringkasan Pembayaran",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Sewa ${bookingData.duration} bulan",
                      formatCurrency(totalPrice - 50000)),
                  _buildSummaryRow("Biaya admin", formatCurrency(50000)),
                  const Divider(),
                  _buildSummaryRow(
                      "Total Pembayaran", formatCurrency(totalPrice),
                      isBold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Pilih Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...paymentMethods.map((group) => _buildMethodGroup(group)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed:
              _selectedMethod == null || _isProcessing ? null : _processPayment,
          child: _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
              : Text('Bayar ${formatCurrency(totalPrice)}'),
        ),
      ),
    );
  }

  Widget _buildMethodGroup(Map<String, dynamic> group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(group['group'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...(group['methods'] as List)
            .map((method) => _buildMethodTile(method))
            ,
      ],
    );
  }

  Widget _buildMethodTile(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['id'];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: isSelected
          ? AppTheme.primaryColor.withAlpha(26)
          : Theme.of(context).inputDecorationTheme.fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 1.5),
      ),
      child: ListTile(
        leading: Icon(method['icon'] as IconData,
            color: isSelected ? AppTheme.primaryColor : Colors.grey),
        title: Text(method['name'] as String),
        trailing: Text(
            (method['fee'] as int) > 0
                ? '+${formatCurrency(method['fee'] as int)}'
                : 'Gratis',
            style: TextStyle(
                color: (method['fee'] as int) > 0 ? Colors.grey : Colors.green,
                fontWeight: FontWeight.bold)),
        onTap: () => setState(() => _selectedMethod = method['id'] as String),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: isBold ? null : Colors.grey[600])),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? AppTheme.primaryColor : null,
                  fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}
