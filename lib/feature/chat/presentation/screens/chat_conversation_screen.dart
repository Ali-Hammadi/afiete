import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatConversationArgs {
  final String sessionId;
  final String doctorId;
  final String patientId;
  final String doctorName;

  const ChatConversationArgs({
    required this.sessionId,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
  });
}

class ChatConversationScreen extends StatefulWidget {
  final ChatConversationArgs args;

  const ChatConversationScreen({super.key, required this.args});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<_ChatMessageItem> _messages;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _messages = <_ChatMessageItem>[
      _ChatMessageItem(
        id: '1',
        text: 'Hello! Are you ready for our therapy session?',
        sentAt: now.subtract(const Duration(minutes: 2)),
        isMine: false,
      ),
      _ChatMessageItem(
        id: '2',
        text:
            'Hello Doctor, I am ready for our session. I just joined the waiting room.',
        sentAt: now.subtract(const Duration(minutes: 1, seconds: 30)),
        isMine: true,
      ),
      _ChatMessageItem(
        id: '3',
        text:
            'Great! I will see you in 2 minutes. I am finishing up with another patient.',
        sentAt: now.subtract(const Duration(minutes: 1)),
        isMine: false,
      ),
      _ChatMessageItem(
        id: '4',
        text: 'Sounds good, thank you.',
        sentAt: now.subtract(const Duration(seconds: 30)),
        isMine: true,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final value = _messageController.text.trim();
    if (value.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessageItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: value,
          sentAt: DateTime.now(),
          isMine: true,
        ),
      );
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarybackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primarybackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage(ImageLinks.woman1),
              backgroundColor: AppColors.primaryFillColor,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.whiteColor, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.args.doctorName, style: AppStyles.bodyMedium),
                  Text(
                    'online',
                    style: AppStyles.bodySmall.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam, color: AppColors.primaryColor),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 58,
            backgroundImage: const AssetImage(ImageLinks.woman1),
            backgroundColor: AppColors.primaryFillColor,
          ),
          const SizedBox(height: 10),
          Text(widget.args.doctorName, style: AppStyles.headingMedium),
          TextButton(onPressed: () {}, child: const Text('View Profile')),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        'Today',
                        style: AppStyles.bodySmall.copyWith(fontSize: 22),
                      ),
                    ),
                  );
                }

                final message = _messages[index - 1];
                return _MessageBubble(message: message);
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryFillColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: AppStyles.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessageItem message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat('h:mm a').format(message.sentAt);

    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMine ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isMine ? 20 : 4),
            bottomRight: Radius.circular(message.isMine ? 4 : 20),
          ),
          border: message.isMine
              ? null
              : Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: AppStyles.bodyMedium.copyWith(
                color: message.isMine
                    ? AppColors.whiteColor
                    : AppColors.primarytextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: AppStyles.bodySmall.copyWith(
                color: message.isMine
                    ? AppColors.whiteColor.withValues(alpha: 0.85)
                    : AppColors.secondarytextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageItem {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMine;

  const _ChatMessageItem({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMine,
  });
}
