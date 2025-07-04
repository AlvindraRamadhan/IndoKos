import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<BookingHistoryItem> _mockBookingHistory = [
    BookingHistoryItem(
      id: 'IK12345678',
      kosName: 'Kos Melati Residence',
      kosAddress: 'Jl. Sudirman No. 123, Jakarta Pusat',
      kosImage:
          'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=400',
      checkInDate: '2025-01-10',
      duration: 6,
      totalAmount: 9050000,
      status: 'Sedang Berlangsung',
      bookingDate: '2025-01-10',
      paymentMethod: 'GoPay',
    ),
    BookingHistoryItem(
      id: 'IK12345677',
      kosName: 'Kos Anggrek Premium',
      kosAddress: 'Jl. Thamrin No. 78, Jakarta Pusat',
      kosImage:
          'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=400',
      checkInDate: '2024-11-25',
      duration: 3,
      totalAmount: 6050000,
      status: 'Selesai',
      bookingDate: '2024-11-25',
      paymentMethod: 'BCA Virtual Account',
    ),
    BookingHistoryItem(
      id: 'IK12345676',
      kosName: 'Kos Dahlia Syariah',
      kosAddress: 'Jl. Kuningan No. 34, Jakarta Selatan',
      kosImage:
          'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=400',
      checkInDate: '2024-01-20',
      duration: 1,
      totalAmount: 1850000,
      status: 'Dikonfirmasi',
      bookingDate: '2024-01-20',
      paymentMethod: 'OVO',
    ),
    BookingHistoryItem(
      id: 'IK12345675',
      kosName: 'Kos Mawar Indah',
      kosAddress: 'Jl. Gatot Subroto No. 45, Jakarta Selatan',
      kosImage:
          'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=400',
      checkInDate: '2023-10-10',
      duration: 2,
      totalAmount: 2450000,
      status: 'Dibatalkan',
      bookingDate: '2023-10-10',
      paymentMethod: 'DANA',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Semua (4)'),
            Tab(text: 'Pending (0)'),
            Tab(text: 'Dikonfirmasi (1)'),
            Tab(text: 'Selesai (1)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(_mockBookingHistory),
          _buildEmptyState("Tidak ada pesanan pending."),
          _buildBookingList(_mockBookingHistory
              .where((b) => b.status == 'Dikonfirmasi')
              .toList()),
          _buildBookingList(
              _mockBookingHistory.where((b) => b.status == 'Selesai').toList()),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Semua pesanan Anda akan muncul di sini.",
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingHistoryItem> bookings) {
    if (bookings.isEmpty) {
      // 'if' statement dibungkus block
      return _buildEmptyState("Tidak ada riwayat pemesanan.");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(bookings[index]);
      },
    );
  }

  Widget _buildHistoryCard(BookingHistoryItem booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withAlpha(51)), // Diperbaiki
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID: ${booking.id}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusBgColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                        color: getStatusTextColor(booking.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            Text(
                'Dipesan: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(booking.bookingDate))}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const Divider(height: 24),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: booking.kosImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.kosName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.kosAddress,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                      "Check-in",
                      booking.checkInDate.isEmpty
                          ? "-"
                          : DateFormat('dd MMM yy')
                              .format(DateTime.parse(booking.checkInDate))),
                  const VerticalDivider(),
                  _buildInfoColumn("Durasi", "${booking.duration} bulan"),
                  const VerticalDivider(),
                  _buildInfoColumn("Total", formatCurrency(booking.totalAmount),
                      isPrice: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  // Urutan argumen diperbaiki
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300)),
                    onPressed: () {},
                    child: const Text("Lihat Detail"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // Urutan argumen diperbaiki
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: booking.status == 'Dikonfirmasi'
                            ? Colors.green
                            : AppTheme.primaryColor),
                    onPressed: () {},
                    child: Text(booking.status == 'Dikonfirmasi'
                        ? 'Siap Check-in'
                        : 'Hubungi Pemilik'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool isPrice = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isPrice
                  ? AppTheme.primaryColor
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
