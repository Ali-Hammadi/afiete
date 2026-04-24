import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:afiete/feature/chat/presentation/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';

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

  late final List<ChatMessageItem> _messages;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _messages = <ChatMessageItem>[
      ChatMessageItem(
        id: '1',
        text: 'Hello! Are you ready for our therapy session?',
        sentAt: now.subtract(const Duration(minutes: 2)),
        isMine: false,
      ),
      ChatMessageItem(
        id: '2',
        text:
            'Hello Doctor, I am ready for our session. I just joined the waiting room.',
        sentAt: now.subtract(const Duration(minutes: 1, seconds: 30)),
        isMine: true,
      ),
      ChatMessageItem(
        id: '3',
        text:
            'Great! I will see you in 2 minutes. I am finishing up with another patient.',
        sentAt: now.subtract(const Duration(minutes: 1)),
        isMine: false,
      ),
      ChatMessageItem(
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
        ChatMessageItem(
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage(ImageLinks.woman1),
              backgroundColor: colorScheme.primaryContainer.withValues(
                alpha: 0.45,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.cardColor, width: 1.5),
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
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.videocam, color: colorScheme.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call, color: colorScheme.primary),
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
            backgroundColor: colorScheme.primaryContainer.withValues(
              alpha: 0.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.args.doctorName, style: AppStyles.headingMedium),
          TextButton(
            onPressed: () {},
            child: Text(SettingsStrings.viewProfile),
          ),
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
                        SettingsStrings.todayLabel,
                        style: AppStyles.bodySmall.copyWith(fontSize: 22),
                      ),
                    ),
                  );
                }

                final message = _messages[index - 1];
                return CustomChatMessageBubble(message: message);
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
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: AppStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: SettingsStrings.typeMessageHint,
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
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: colorScheme.onPrimary),
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
