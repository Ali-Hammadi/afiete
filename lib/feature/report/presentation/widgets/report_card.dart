import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';

class CustomReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onTap;

  const CustomReportCard({super.key, required this.report, this.onTap});

  Color _getStatusBackgroundColor(ColorScheme colorScheme) {
    switch (report.status) {
      case ReportStatus.pending:
        return colorScheme.secondary;
      case ReportStatus.reviewed:
        return colorScheme.primary;
      case ReportStatus.resolved:
        return colorScheme.primaryContainer;
    }
  }

  Color _getStatusTextColor(ColorScheme colorScheme) {
    switch (report.status) {
      case ReportStatus.pending:
        return colorScheme.onSecondary;
      case ReportStatus.reviewed:
        return colorScheme.onPrimary;
      case ReportStatus.resolved:
        return colorScheme.onPrimaryContainer;
    }
  }

  String _getStatusLabel() {
    switch (report.status) {
      case ReportStatus.pending:
        return SettingsStrings.pendingStatus;
      case ReportStatus.reviewed:
        return SettingsStrings.underReviewStatus;
      case ReportStatus.resolved:
        return SettingsStrings.resolvedStatus;
    }
  }

  String _getReportTypeLabel() {
    switch (report.reportType) {
      case ReportType.doctor:
        return SettingsStrings.doctorReportType;
      case ReportType.session:
        return SettingsStrings.sessionReportType;
      case ReportType.app:
        return SettingsStrings.appReportType;
    }
  }

  String _getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy at hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusBgColor = _getStatusBackgroundColor(colorScheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppStyles.padding),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.35),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          color: theme.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getReportTypeLabel(),
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: AppStyles.bodySmall.copyWith(
                      color: _getStatusTextColor(colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Target Name (if doctor or session)
            if (report.targetName != null) ...[
              Text(
                report.targetName!,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Reason
            Row(
              children: [
                Text(
                  SettingsStrings.reasonLabel,
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.reason.label,
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description (truncated)
            Text(
              report.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 12),

            // Footer: Date and divider
            Container(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.35),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${SettingsStrings.submittedLabel}: ${_getFormattedDate(report.createdAt)}',
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                if (report.resolvedAt != null)
                  Text(
                    '${SettingsStrings.resolvedLabel}: ${_getFormattedDate(report.resolvedAt!)}',
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
