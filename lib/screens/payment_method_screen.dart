import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metode Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile<String>(
            title: const Text('Bank Transfer'),
            subtitle: const Text('Transfer via ATM/Mobile Banking'),
            value: 'Bank Transfer',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('E-Wallet'),
            subtitle: const Text('OVO, Gopay, Dana, dll'),
            value: 'E-Wallet',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Kartu Kredit'),
            subtitle: const Text('Visa, Mastercard, dll'),
            value: 'Kartu Kredit',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Alfamart/Indomaret'),
            subtitle: const Text('Bayar di gerai terdekat'),
            value: 'Alfamart/Indomaret',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_selectedMethod != null) {
                  Navigator.pop(context, _selectedMethod);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih metode pembayaran terlebih dahulu'),
                    ),
                  );
                }
              },
              child: const Text('Pilih Metode Ini'),
            ),
          ),
        ],
      ),
    );
  }
}
