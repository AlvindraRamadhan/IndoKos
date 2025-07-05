import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ChatRoom> _mockChatRooms = [
    ChatRoom(
        id: '1',
        name: 'Ibu Sari (Kos Melati)',
        avatar:
            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        lastMessage: 'Baik, kamar sudah siap untuk check-in besok',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 32)),
        unreadCount: 0,
        isOnline: true),
    ChatRoom(
        id: '2',
        name: 'Pak Budi (Kos Anggrek)',
        avatar:
            'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        lastMessage: 'Untuk deposit bisa transfer ke rekening BCA ya',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 2,
        isOnline: false),
    ChatRoom(
        id: '3',
        name: 'IndoKos Support',
        avatar:
            'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        lastMessage: 'Terima kasih telah menggunakan layanan IndoKos',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          title: const Text('Chat'),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Membeli'),
              Tab(text: 'Menjual'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildChatList(_mockChatRooms),
            _buildEmptyList("Belum ada chat pembelian."),
            _buildEmptyList("Belum ada chat penjualan."),
          ],
        ));
  }

  Widget _buildChatList(List<ChatRoom> rooms) {
    if (rooms.isEmpty) {
      return _buildEmptyList("Tidak ada chat.");
    }

    return ListView.separated(
      itemCount: rooms.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 80, endIndent: 16),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // FIX: Use context.push to preserve the navigation stack
          onTap: () => context.push('/chat/${room.id}', extra: room),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: CachedNetworkImageProvider(room.avatar),
              ),
              if (room.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(room.name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(room.lastMessage,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgoSinceDate(room.lastMessageTime, numericDates: false),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              if (room.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: AppTheme.primaryColor, shape: BoxShape.circle),
                  child: Text(
                    '${room.unreadCount}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyList(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }
}
