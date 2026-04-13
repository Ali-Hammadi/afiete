import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:afiete/feature/payment/domain/usecases/process_payment_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentCubit(this.processPaymentUseCase)
    : super(const PaymentInitial(selectedMethod: PaymentMethod.card));

  PaymentMethod get selectedMethod {
    final current = state;
    if (current is PaymentInitial) {
      return current.selectedMethod;
    }
    if (current is PaymentProcessing) {
      return current.selectedMethod;
    }
    if (current is PaymentFailure) {
      return current.selectedMethod;
    }
    return PaymentMethod.card;
  }

  void selectMethod(PaymentMethod method) {
    emit(PaymentInitial(selectedMethod: method));
  }

  Future<void> processPayment(PaymentRequestEntity request) async {
    emit(PaymentProcessing(selectedMethod: request.method));
    final result = await processPaymentUseCase(request);
    result.fold(
      (failure) => emit(
        PaymentFailure(failure.errorMessage, selectedMethod: request.method),
      ),
      (payment) => emit(PaymentSuccess(payment)),
    );
  }

  void resetToMethodSelection() {
    emit(PaymentInitial(selectedMethod: selectedMethod));
  }
}
