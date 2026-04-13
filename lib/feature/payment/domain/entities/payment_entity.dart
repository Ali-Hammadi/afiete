import 'package:equatable/equatable.dart';

enum PaymentMethod { card, wallet, cash }

enum PaymentStatus { pending, success, failed }

class PaymentRequestEntity extends Equatable {
  final String doctorId;
  final String patientId;
  final String doctorName;
  final DateTime scheduledAt;
  final int durationSlots;
  final String sessionType;
  final double amount;
  final String currency;
  final PaymentMethod method;

  const PaymentRequestEntity({
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.scheduledAt,
    required this.durationSlots,
    required this.sessionType,
    required this.amount,
    this.currency = 'USD',
    required this.method,
  });

  @override
  List<Object?> get props => [
    doctorId,
    patientId,
    doctorName,
    scheduledAt,
    durationSlots,
    sessionType,
    amount,
    currency,
    method,
  ];
}

class PaymentEntity extends Equatable {
  final String id;
  final String transactionRef;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.transactionRef,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  bool get isSuccessful => status == PaymentStatus.success;

  @override
  List<Object?> get props => [
    id,
    transactionRef,
    amount,
    currency,
    method,
    status,
    createdAt,
  ];
}
