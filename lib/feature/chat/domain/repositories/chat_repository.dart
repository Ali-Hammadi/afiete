import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/chat/domain/entities/chat_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String conversationId,
  );

  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  });

  Future<Either<Failure, void>> markMessageAsRead(String messageId);
}
