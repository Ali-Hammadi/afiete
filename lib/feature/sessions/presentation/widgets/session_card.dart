import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/booking_assiments/domain/constants/session_type.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomSessionCard extends StatelessWidget {
  final SessionEntity session;
  final VoidCallback? onAddReview;
  final VoidCallback? onBookAgain;
  final VoidCallback? onReschedule;
  final VoidCallback? onJoinSession;
  final VoidCallback? onCancel;

  const CustomSessionCard({
    super.key,
    required this.session,
    this.onAddReview,
    this.onBookAgain,
    this.onReschedule,
    this.onJoinSession,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM dd, yyyy').format(session.scheduledAt);
    final isPast = !session.isUpcoming;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.person_outline, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.doctorName, style: AppStyles.headingSmall),
                      Text(
                        SettingsStrings.specialtyLabel(
                          session.doctorSpecialization,
                        ),
                        style: AppStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.calendar_today, text: dateText),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.access_time, text: session.timeRange),
            const SizedBox(height: 8),
            SessionType.displayWithIcon(
              session.sessionType,
              textStyle: AppStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context, isPast),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isPast) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isPast) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onAddReview,
              child: Text(SettingsStrings.addReview),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: onBookAgain,
              child: Text(SettingsStrings.bookAgain),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReschedule,
                  child: Text(SettingsStrings.reschedule),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onJoinSession,
                  child: Text(SettingsStrings.joinSession),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: onCancel,
              child: Text(SettingsStrings.cancelAction),
            ),
          ),
        ],
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(text, style: AppStyles.bodyMedium),
      ],
    );
  }
}
