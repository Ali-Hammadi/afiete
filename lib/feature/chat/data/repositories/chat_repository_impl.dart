import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/chat/data/datasources/chat_remote_datasource.dart';
import 'package:afiete/feature/chat/domain/entities/chat_entity.dart';
import 'package:afiete/feature/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource dataSource;

  const ChatRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String conversationId,
  ) async {
    try {
      final result = await dataSource.getMessages(conversationId);
      return Right<Failure, List<ChatMessageEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<ChatMessageEntity>>(
        ServerFailure.fromDioError(e),
      );
    } catch (_) {
      return Left<Failure, List<ChatMessageEntity>>(
        ServerFailure('Unable to load chat messages.'),
      );
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final result = await dataSource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
      return Right<Failure, ChatMessageEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, ChatMessageEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, ChatMessageEntity>(
        ServerFailure('Unable to send message.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      await dataSource.markMessageAsRead(messageId);
      return Right<Failure, void>(null);
    } on DioException catch (e) {
      return Left<Failure, void>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, void>(
        ServerFailure('Unable to mark message as read.'),
      );
    }
  }
}
