class ChatMessageItem {
  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMine;

  const ChatMessageItem({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMine,
  });
}
