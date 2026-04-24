import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/booking_assiments/domain/constants/session_type.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/chat/presentation/helpers/chat_session_navigator.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final DoctorEntity? doctor;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const CustomAppointmentCard({
    super.key,
    required this.appointment,
    this.doctor,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateText = DateFormat(
      'EEE, dd MMM yyyy - hh:mm a',
    ).format(appointment.scheduledAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ImageLinks.man1),
                  radius: 30,
                  backgroundColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.35,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      doctor?.name ?? appointment.doctorName,
                      style: AppStyles.headingSmall,
                    ),
                    subtitle: Text(
                      doctor?.specialization == null
                          ? SettingsStrings.specialistLabelInAppointment
                          : SettingsStrings.specialtyLabel(
                              doctor!.specialization,
                            ),
                      style: AppStyles.bodyMedium,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close_sharp),
                  tooltip: SettingsStrings.cancelAction,
                ),
              ],
            ), //01142611737
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppStyles.padding),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateText, style: AppStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    SettingsStrings.durationMinutesLabel(
                      appointment.durationSlots * 30,
                    ),
                    style: AppStyles.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  SessionType.displayWithIcon(
                    appointment.sessionType,
                    textStyle: AppStyles.bodySmall,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  CustomButton(
                    widget: Text(
                      SettingsStrings.joinSession,
                      style: AppStyles.bodySmall.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () => _handleJoinSession(context),
                  ),
                  CustomButton(
                    widget: Text(
                      SettingsStrings.reschedule,
                      style: AppStyles.bodySmall.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: onReschedule,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleJoinSession(BuildContext context) {
    ChatSessionNavigator.openFromAppointment(
      context,
      appointment,
      doctorName: doctor?.name ?? appointment.doctorName,
    );
  }
}
