import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSummaryCard extends StatelessWidget {
  final PaymentRequestEntity request;

  const PaymentSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryFillColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryRow(
            label: 'Session',
            value: _prettySessionType(request.sessionType),
          ),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Specialist', value: request.doctorName),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Date',
            value: DateFormat(
              'MMM dd, yyyy • h:mm a',
            ).format(request.scheduledAt),
          ),
          const SizedBox(height: 6),
          Divider(color: Colors.black.withValues(alpha: 0.08), height: 18),
          Row(
            children: [
              Text('Total Amount', style: AppStyles.bodyMedium),
              const Spacer(),
              Text(
                '${_formatAmount(request.amount)} \$',
                style: AppStyles.headingMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toStringAsFixed(0);
    }
    return amount.toStringAsFixed(2);
  }

  static String _prettySessionType(String sessionType) {
    return sessionType
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.secondarytextColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppStyles.headingSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
