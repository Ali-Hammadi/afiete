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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<AppointmentsCubit>();
      if (cubit.state is AppointmentsInitial) {
        cubit.loadAppointments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTabSelector(theme: theme, colorScheme: colorScheme),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
                builder: _buildStateBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.all(AppStyles.padding / 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildTabItem(
              title: 'Upcoming',
              isSelected: isUpcoming,
              colorScheme: colorScheme,
              onTap: () {
                setState(() {
                  isUpcoming = true;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTabItem(
              title: 'Past',
              isSelected: !isUpcoming,
              colorScheme: colorScheme,
              onTap: () {
                setState(() {
                  isUpcoming = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      ),
      padding: const EdgeInsets.all(AppStyles.padding / 2),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: AppStyles.headingSmall.copyWith(
            color: isSelected ? colorScheme.onPrimaryContainer : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStateBody(BuildContext context, AppointmentsState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state is AppointmentsLoading || state is AppointmentsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AppointmentsError) {
      return _buildErrorState(
        context: context,
        colorScheme: colorScheme,
        message: state.message,
      );
    }

    if (state is AppointmentsLoaded) {
      return _buildLoadedState(context: context, state: state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState({
    required BuildContext context,
    required ColorScheme colorScheme,
    required String message,
  }) {
    final lowerMessage = message.toLowerCase();
    final isConnectionIssue =
        lowerMessage.contains('internet') ||
        lowerMessage.contains('network') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('socket');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnectionIssue
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              size: 42,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 10),
            Text(
              isConnectionIssue
                  ? 'No internet connection. Please reconnect and try again.'
                  : message,
              style: AppStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AppointmentsCubit>().loadAppointments();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState({
    required BuildContext context,
    required AppointmentsLoaded state,
  }) {
    final now = DateTime.now();
    final filteredAppointments = state.appointments.where((appointment) {
      final isUpcomingAppointment = appointment.scheduledAt.isAfter(now);
      return isUpcoming ? isUpcomingAppointment : !isUpcomingAppointment;
    }).toList();

    if (filteredAppointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: () {
          return context.read<AppointmentsCubit>().loadAppointments();
        },
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                isUpcoming
                    ? 'No upcoming appointments.'
                    : 'No past appointments.',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return context.read<AppointmentsCubit>().loadAppointments();
      },
      child: ListView.builder(
        itemCount: filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          final matchedDoctor = _findDoctorForAppointment(
            state.doctors,
            appointment.doctorId,
          );

          return CustomAppointmentCard(
            doctor: matchedDoctor,
            appointment: appointment,
          );
        },
      ),
    );
  }

  DoctorEntity? _findDoctorForAppointment(
    List<DoctorEntity>? doctors,
    String doctorId,
  ) {
    final list = doctors ?? const <DoctorEntity>[];

    for (final doctor in list) {
      if (doctor.id == doctorId) {
        return doctor;
      }
    }

    return null;
  }
}
