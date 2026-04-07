import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'package:afiete/feature/booking_assiments/presentation/widgets/appointment_card.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppStyles.padding / 2),
            decoration: BoxDecoration(
              color: AppColors.primaryFillColor,
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? AppColors.primarybackgroundColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                    ),
                    padding: const EdgeInsets.all(AppStyles.padding / 2),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isUpcoming = true;
                        });
                      },
                      child: Text(
                        "Upcoming",
                        style: AppStyles.headingSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isUpcoming
                          ? AppColors.primarybackgroundColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                    ),
                    padding: const EdgeInsets.all(AppStyles.padding / 2),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isUpcoming = false;
                        });
                      },
                      child: Text(
                        "Past",
                        style: AppStyles.headingSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoading ||
                    state is AppointmentsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AppointmentsError) {
                  return Center(
                    child: Text(state.message, style: AppStyles.bodyMedium),
                  );
                }

                if (state is AppointmentsLoaded) {
                  final now = DateTime.now();
                  final filteredAppointments = state.appointments.where((apt) {
                    final isUpcomingApt = apt.scheduledAt.isAfter(now);
                    return isUpcoming ? isUpcomingApt : !isUpcomingApt;
                  }).toList();

                  if (filteredAppointments.isEmpty) {
                    return Center(
                      child: Text(
                        isUpcoming
                            ? 'No upcoming appointments.'
                            : 'No past appointments.',
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return context
                          .read<AppointmentsCubit>()
                          .loadAppointments();
                    },
                    child: ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];
                        final doctors = state.doctors ?? const <DoctorEntity>[];
                        DoctorEntity? matchedDoctor;

                        for (final doctor in doctors) {
                          if (doctor.id == appointment.doctorId) {
                            matchedDoctor = doctor;
                            break;
                          }
                        }

                        return CustomAppointmentCard(
                          doctor: matchedDoctor,
                          appointment: appointment,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
