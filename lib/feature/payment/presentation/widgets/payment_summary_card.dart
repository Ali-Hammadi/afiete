import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomPaymentSummaryCard extends StatelessWidget {
  final PaymentRequestEntity request;

  const CustomPaymentSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryRow(
            label: SettingsStrings.sessionLabel,
            value: _prettySessionType(request.sessionType),
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: SettingsStrings.specialistLabel,
            value: request.doctorName,
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: SettingsStrings.dateLabel,
            value: DateFormat(
              'MMM dd, yyyy • h:mm a',
            ).format(request.scheduledAt),
          ),
          const SizedBox(height: 6),
          Divider(
            color: colorScheme.outline.withValues(alpha: 0.35),
            height: 18,
          ),
          Row(
            children: [
              Text(
                SettingsStrings.totalAmountLabel,
                style: AppStyles.bodyMedium,
              ),
              const Spacer(),
              Text(
                '${_formatAmount(request.amount)} \$',
                style: AppStyles.headingMedium.copyWith(
                  color: colorScheme.primary,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppStyles.headingSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
