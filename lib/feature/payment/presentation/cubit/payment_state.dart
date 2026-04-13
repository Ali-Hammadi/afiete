part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  final PaymentMethod selectedMethod;

  const PaymentInitial({required this.selectedMethod});

  @override
  List<Object?> get props => [selectedMethod];
}

class PaymentProcessing extends PaymentState {
  final PaymentMethod selectedMethod;

  const PaymentProcessing({required this.selectedMethod});

  @override
  List<Object?> get props => [selectedMethod];
}

class PaymentSuccess extends PaymentState {
  final PaymentEntity payment;

  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentFailure extends PaymentState {
  final String message;
  final PaymentMethod selectedMethod;

  const PaymentFailure(this.message, {required this.selectedMethod});

  @override
  List<Object?> get props => [message, selectedMethod];
}
