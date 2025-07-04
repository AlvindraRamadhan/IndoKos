import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models.dart';
import 'utils.dart';
import 'app_theme.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatRoom> _mockChatRooms = [
    ChatRoom(
      id: '1',
      name: 'Ibu Sari (Kos Melati)',
      avatar:
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      lastMessage: 'Baik, kamar sudah siap untuk check-in besok',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 32)),
      unreadCount: 0,
      isOnline: true,
    ),
    ChatRoom(
      id: '2',
      name: 'Pak Budi (Kos Anggrek)',
      avatar:
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      lastMessage: 'Untuk deposit bisa transfer ke rekening BCA ya',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
      isOnline: false,
    ),
    ChatRoom(
      id: '3',
      name: 'IndoKos Support',
      avatar:
          'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      lastMessage: 'Terima kasih telah menggunakan layanan IndoKos',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari chat...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _mockChatRooms.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 80, endIndent: 16),
              itemBuilder: (context, index) {
                final room = _mockChatRooms[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {/* Navigasi ke detail chat */},
                  leading: Stack(
                    children: [
                      CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              CachedNetworkImageProvider(room.avatar)),
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
                          timeAgoSinceDate(room.lastMessageTime,
                              numericDates: false),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      if (room.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle),
                          child: Text('${room.unreadCount}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
