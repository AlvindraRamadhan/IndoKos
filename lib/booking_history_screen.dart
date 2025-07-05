import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models.dart';
import 'app_theme.dart';
import 'utils.dart'; // For formatCurrency

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<BookingHistoryItem> _mockHistory = [
    BookingHistoryItem(
        id: '1',
        kosName: 'Kos Melati Residence',
        kosAddress: 'Jl. Sudirman No. 123, Jakarta Pusat',
        kosImage:
            'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        checkInDate: '2025-08-01',
        duration: 1,
        totalAmount: 1550000,
        status: 'Selesai',
        bookingDate: '2025-07-01',
        paymentMethod: 'BCA Virtual Account'),
    BookingHistoryItem(
        id: '2',
        kosName: 'Kos Anggrek Premium',
        kosAddress: 'Jl. Thamrin No. 78, Jakarta Pusat',
        kosImage:
            'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        checkInDate: '2025-07-15',
        duration: 3,
        totalAmount: 6050000,
        status: 'Dikonfirmasi',
        bookingDate: '2025-07-05',
        paymentMethod: 'GoPay'),
    BookingHistoryItem(
        id: '3',
        kosName: 'Kos Mawar Indah',
        kosAddress: 'Jl. Gatot Subroto No. 45, Jakarta Selatan',
        kosImage:
            'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        checkInDate: '2025-06-20',
        duration: 1,
        totalAmount: 1250000,
        status: 'Dibatalkan',
        bookingDate: '2025-06-10',
        paymentMethod: 'OVO'),
    BookingHistoryItem(
        id: '4',
        kosName: 'Wisma Cendana Putri',
        kosAddress: 'Jl. Diponegoro No. 22, Surabaya',
        kosImage:
            'https://images.pexels.com/photos/2102587/pexels-photo-2102587.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        checkInDate: '2025-08-10',
        duration: 6,
        totalAmount: 7850000,
        status: 'Pending',
        bookingDate: '2025-07-04',
        paymentMethod: 'Transfer Bank'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          isScrollable: true, // Allows tabs to scroll horizontally
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          tabs: [
            Tab(text: 'Semua (${_mockHistory.length})'),
            Tab(
                text:
                    'Pending (${_mockHistory.where((i) => i.status == 'Pending').length})'),
            Tab(
                text:
                    'Dikonfirmasi (${_mockHistory.where((i) => i.status == 'Dikonfirmasi').length})'),
            Tab(
                text:
                    'Selesai (${_mockHistory.where((i) => i.status == 'Selesai').length})'),
            Tab(
                text:
                    'Dibatalkan (${_mockHistory.where((i) => i.status == 'Dibatalkan').length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList(_mockHistory),
          _buildHistoryList(
              _mockHistory.where((i) => i.status == 'Pending').toList()),
          _buildHistoryList(
              _mockHistory.where((i) => i.status == 'Dikonfirmasi').toList()),
          _buildHistoryList(
              _mockHistory.where((i) => i.status == 'Selesai').toList()),
          _buildHistoryList(
              _mockHistory.where((i) => i.status == 'Dibatalkan').toList()),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<BookingHistoryItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_rounded,
                size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("Tidak ada riwayat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Riwayat pemesanan Anda akan muncul di sini.",
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(items[index]);
      },
    );
  }

  Widget _buildHistoryCard(BookingHistoryItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text("ID: ${item.id}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const Spacer(),
                _buildStatusChip(item.status),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.kosImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.kosName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        item.kosAddress,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(formatCurrency(item.totalAmount),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () {}, child: const Text("Lihat Detail")),
                const SizedBox(width: 8),
                if (item.status == 'Dikonfirmasi')
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Hubungi Pemilik")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color textColor;
    switch (status) {
      case 'Pending':
        color = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'Dikonfirmasi':
        color = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'Selesai':
        color = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Dibatalkan':
        color = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        color = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
