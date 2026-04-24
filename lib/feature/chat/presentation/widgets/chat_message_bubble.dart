import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/chat/presentation/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomChatMessageBubble extends StatelessWidget {
  final ChatMessageItem message;

  const CustomChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeText = DateFormat('h:mm a').format(message.sentAt);

    return Align(
      alignment:
          message.isMine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMine ? colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(20),
            topEnd: const Radius.circular(20),
            bottomStart: Radius.circular(message.isMine ? 20 : 4),
            bottomEnd: Radius.circular(message.isMine ? 4 : 20),
          ),
          border: message.isMine
              ? null
              : Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: AppStyles.bodyMedium.copyWith(
                color: message.isMine
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: AppStyles.bodySmall.copyWith(
                color: message.isMine
                    ? colorScheme.onPrimary.withValues(alpha: 0.85)
                    : colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
