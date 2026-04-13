import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> processPayment(
    PaymentRequestEntity request,
  );
}
