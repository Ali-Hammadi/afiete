import 'package:afiete/feature/chat/data/datasources/chat_remote_datasource.dart';
import 'package:afiete/feature/chat/data/models/chat_message_model.dart';

class ChatMockDataSourceImpl implements ChatRemoteDataSource {
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      id: 'msg_1',
      conversationId: 'conv_1',
      senderId: 'doctor_1',
      receiverId: 'patient_1',
      message: 'Hello, how are you feeling today?',
      sentAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: true,
    ),
    ChatMessageModel(
      id: 'msg_2',
      conversationId: 'conv_1',
      senderId: 'patient_1',
      receiverId: 'doctor_1',
      message: 'I am better, thank you doctor.',
      sentAt: DateTime.now().subtract(const Duration(minutes: 9)),
      isRead: false,
    ),
  ];

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final result = _messages
        .where((item) => item.conversationId == conversationId)
        .toList(growable: false);
    return result;
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    final created = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      sentAt: DateTime.now(),
      isRead: false,
    );

    _messages.add(created);
    return created;
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final index = _messages.indexWhere((item) => item.id == messageId);
    if (index == -1) {
      return;
    }

    final current = _messages[index];
    _messages[index] = ChatMessageModel(
      id: current.id,
      conversationId: current.conversationId,
      senderId: current.senderId,
      receiverId: current.receiverId,
      message: current.message,
      sentAt: current.sentAt,
      isRead: true,
    );
  }
}
