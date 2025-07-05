import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'models.dart';
import 'app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  const ChatDetailScreen({super.key, required this.chatRoom});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
        id: '1',
        senderId: 'other',
        message: 'Halo, apakah kos masih tersedia?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    ChatMessage(
        id: '2',
        senderId: 'me',
        message: 'Halo, masih tersedia. Silakan.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    ChatMessage(
        id: '3',
        senderId: 'other',
        message: 'Baik, kamar sudah siap untuk check-in besok',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2))),
  ];
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  CachedNetworkImageProvider(widget.chatRoom.avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chatRoom.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  if (widget.chatRoom.isOnline)
                    Text("Online",
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                final isMe = message.senderId == 'me';
                return _buildMessageBubble(isMe, message.message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isMe, String message) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: isMe
                ? AppTheme.primaryColor
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: isMe ? null : Border.all(color: Colors.grey.shade300)),
        child: Text(
          message,
          style: TextStyle(
              color: isMe
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            // FIX: Replaced withOpacity with withAlpha
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan...',
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white),
            onPressed: () {
              // Send message logic
            },
          )
        ],
      ),
    );
  }
}
