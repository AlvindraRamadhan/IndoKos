import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'semua';

  final List<NotificationItem> _mockNotifications = [
    NotificationItem(
      id: '1',
      title: 'Pembayaran Berhasil',
      message:
          'Pembayaran untuk Kos Melati Residence telah berhasil diproses. ID: IK12345678',
      type: 'payment',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      actionUrl: '/booking-history',
    ),
    NotificationItem(
      id: '2',
      title: 'Pemesanan Dikonfirmasi',
      message:
          'Pemesanan Anda di Kos Anggrek Premium telah dikonfirmasi oleh pemilik kos.',
      type: 'booking',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionUrl: '/booking-history',
    ),
    NotificationItem(
      id: '3',
      title: 'Promo Spesial Hari Ini!',
      message:
          'Dapatkan diskon 20% untuk kos premium di Jakarta. Berlaku hingga hari ini!',
      type: 'promo',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Pesan dari Pemilik Kos',
      message:
          'Ibu Sari: "Selamat datang! Jangan lupa bawa KTP untuk check-in besok ya."',
      type: 'message',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
      actionUrl: '/chat',
    ),
    NotificationItem(
      id: '5',
      title: 'Reminder Check-in',
      message:
          'Jangan lupa, jadwal check-in Anda di Kos Melati Residence adalah besok.',
      type: 'reminder',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  // Metode ini sekarang akan digunakan
  IconData _getIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.check_circle_rounded;
      case 'booking':
        return Icons.bookmark_added_rounded;
      case 'promo':
        return Icons.campaign_rounded;
      case 'message':
        return Icons.chat_bubble_rounded;
      case 'reminder':
        return Icons.notifications_active_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // Metode ini sekarang akan digunakan
  Color _getIconColor(String type) {
    switch (type) {
      case 'payment':
        return Colors.blue;
      case 'booking':
        return Colors.green;
      case 'promo':
        return Colors.orange;
      case 'message':
        return AppTheme.primaryColor;
      case 'reminder':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _mockNotifications.where((n) => !n.isRead).length;
    final filtered = _selectedFilter == 'semua'
        ? _mockNotifications
        : _mockNotifications.where((n) => !n.isRead).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Tandai Semua"))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'semua',
                    label: Text('Semua (${_mockNotifications.length})')),
                ButtonSegment(
                    value: 'belum_dibaca',
                    label: Text('Belum Dibaca ($unreadCount)')),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (Set<String> newSelection) =>
                  setState(() => _selectedFilter = newSelection.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppTheme.primaryColor.withAlpha(51),
                selectedForegroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final notif = filtered[index];
                return InkWell(
                  onTap: () {
                    if (notif.actionUrl != null) {
                      context.go(notif.actionUrl!);
                    }
                    setState(() {
                      notif.isRead = true;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withAlpha(51)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // **BAGIAN YANG DIPERBAIKI**
                        // Memanggil _getIcon dan _getIconColor untuk menampilkan ikon
                        CircleAvatar(
                          backgroundColor:
                              _getIconColor(notif.type).withAlpha(26),
                          child: Icon(_getIcon(notif.type),
                              color: _getIconColor(notif.type)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: notif.isRead
                                          ? Colors.grey[600]
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color)),
                              const SizedBox(height: 4),
                              Text(notif.message,
                                  style: TextStyle(color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Text(
                                  timeAgoSinceDate(notif.timestamp,
                                      numericDates: false),
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12)),
                            ],
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 12),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
