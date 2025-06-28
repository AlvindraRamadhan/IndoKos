import 'package:flutter/material.dart';
import 'package:indokos/utils/mock_data.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pemesanan')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockBookings.length,
        itemBuilder: (context, index) {
          final booking = mockBookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.kosName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${booking.startDate.day}/${booking.startDate.month}/${booking.startDate.year} - '
                    '${booking.endDate.day}/${booking.endDate.month}/${booking.endDate.year}',
                  ),
                  const SizedBox(height: 8),
                  Text(booking.location),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.status,
                        style: TextStyle(
                          color: booking.status == 'Selesai'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement review
                        },
                        child: const Text('Tulis Ulasan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
