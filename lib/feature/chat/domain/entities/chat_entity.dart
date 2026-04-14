import 'package:equatable/equatable.dart';

class ChatConversationEntity extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime updatedAt;

  const ChatConversationEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, doctorId, patientId, updatedAt];
}

class ChatMessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime sentAt;
  final bool isRead;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    receiverId,
    message,
    sentAt,
    isRead,
  ];
}
