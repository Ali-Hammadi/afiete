import 'package:afiete/feature/payment/data/datasources/payment_remote_datasource.dart';
import 'package:afiete/feature/payment/data/models/payment_model.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';

class PaymentMockDataSourceImpl implements PaymentRemoteDataSource {
  @override
  Future<PaymentModel> processPayment(PaymentRequestEntity request) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaymentModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      transactionRef: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      amount: request.amount,
      currency: request.currency,
      method: request.method,
      status: PaymentStatus.success,
      createdAt: DateTime.now(),
    );
  }
}
