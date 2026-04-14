import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class MarkChatMessageReadUseCase
    implements UseCase<void, MarkChatMessageReadParams> {
  final ChatRepository repository;

  const MarkChatMessageReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkChatMessageReadParams params) {
    return repository.markMessageAsRead(params.messageId);
  }
}

class MarkChatMessageReadParams {
  final String messageId;

  const MarkChatMessageReadParams({required this.messageId});
}
