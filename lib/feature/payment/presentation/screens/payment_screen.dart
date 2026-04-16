import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:afiete/feature/payment/presentation/cubit/payment_cubit.dart';
import 'package:afiete/feature/payment/presentation/widgets/payment_input_field.dart';
import 'package:afiete/feature/payment/presentation/widgets/payment_method_tile.dart';
import 'package:afiete/feature/payment/presentation/widgets/payment_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentRequestEntity request;

  const PaymentScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Payment', style: AppStyles.headingMedium),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment successful: ${state.payment.transactionRef}',
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyRoutes.homeScreen,
              (route) => false,
            );
          }

          if (state is PaymentFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<PaymentCubit>();
          final selectedMethod = cubit.selectedMethod;
          final isProcessing = state is PaymentProcessing;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPaymentSummaryCard(request: request),
                          const SizedBox(height: 28),
                          Text(
                            'Payment Method',
                            style: AppStyles.headingMedium,
                          ),
                          const SizedBox(height: 12),
                          CustomPaymentMethodTile(
                            title: 'Credit / Debit Card',
                            icon: Icons.credit_card_outlined,
                            selected: selectedMethod == PaymentMethod.card,
                            onTap: isProcessing
                                ? null
                                : () => cubit.selectMethod(PaymentMethod.card),
                          ),
                          const SizedBox(height: 10),
                          CustomPaymentMethodTile(
                            title: 'Apple Pay',
                            icon: Icons.apple,
                            selected: selectedMethod == PaymentMethod.wallet,
                            onTap: isProcessing
                                ? null
                                : () =>
                                      cubit.selectMethod(PaymentMethod.wallet),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Card Information',
                            style: AppStyles.headingSmall,
                          ),
                          const SizedBox(height: 8),
                          CustomPaymentInputField(
                            hint: '0000 0000 0000 0000',
                            prefixIcon: Icons.credit_card,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Expanded(
                                child: CustomPaymentInputField(
                                  label: 'Expiry Date',
                                  hint: 'MM/YY',
                                ),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: CustomPaymentInputField(
                                  label: 'CVV',
                                  hint: '123',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const CustomPaymentInputField(
                            label: 'Cardholder Name',
                            hint: 'Name on card',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 180,
                      child: CustomButton(
                        widget: isProcessing
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                'Pay ${_formatAmount(request.amount)} \$',
                                style: AppStyles.headingSmall.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                        onPressed: isProcessing
                            ? null
                            : () {
                                final finalRequest = PaymentRequestEntity(
                                  doctorId: request.doctorId,
                                  patientId: request.patientId,
                                  doctorName: request.doctorName,
                                  scheduledAt: request.scheduledAt,
                                  durationSlots: request.durationSlots,
                                  sessionType: request.sessionType,
                                  amount: request.amount,
                                  currency: request.currency,
                                  method: selectedMethod,
                                );
                                cubit.processPayment(finalRequest);
                              },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toStringAsFixed(0);
    }
    return amount.toStringAsFixed(2);
  }
}
