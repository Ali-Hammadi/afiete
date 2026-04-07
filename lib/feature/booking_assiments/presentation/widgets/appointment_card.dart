import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/booking_assiments/domain/constants/session_type.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final DoctorEntity? doctor;

  const AppointmentCard({super.key, required this.appointment, this.doctor});

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat(
      'EEE, dd MMM yyyy - hh:mm a',
    ).format(appointment.scheduledAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
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
                  backgroundColor: AppColors.primaryFillColor,
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
                      doctor?.specialization ?? 'Specialist',
                      style: AppStyles.bodyMedium,
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.close_sharp)),
              ],
            ), //01142611737
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppStyles.padding),
              decoration: BoxDecoration(
                color: AppColors.primaryFillColor,
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateText, style: AppStyles.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Duration: ${appointment.durationSlots * 30} minutes',
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
                      "Join Session",
                      style: AppStyles.bodySmall.copyWith(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                  CustomButton(
                    widget: Text(
                      "Reschedule",
                      style: AppStyles.bodySmall.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      // Handle cancel action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
