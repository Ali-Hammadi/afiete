import 'package:afiete/feature/chat/data/models/chat_message_model.dart';
import 'package:dio/dio.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> getMessages(String conversationId);

  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  });

  Future<void> markMessageAsRead(String messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  const ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final response = await dio.get(
      '/chat/messages',
      queryParameters: {'conversationId': conversationId},
    );

    final data = response.data as List<dynamic>;
    return data
        .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final response = await dio.post(
      '/chat/messages',
      data: {
        'conversationId': conversationId,
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
      },
    );

    return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await dio.patch('/chat/messages/$messageId/read');
  }
}
