import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/chat/domain/entities/chat_entity.dart';
import 'package:afiete/feature/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatMessagesUseCase
    implements UseCase<List<ChatMessageEntity>, GetChatMessagesParams> {
  final ChatRepository repository;

  const GetChatMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(
    GetChatMessagesParams params,
  ) {
    return repository.getMessages(params.conversationId);
  }
}

class GetChatMessagesParams {
  final String conversationId;

  const GetChatMessagesParams({required this.conversationId});
}
