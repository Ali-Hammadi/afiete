import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/booking_assiments/domain/constants/session_type.dart';
import 'package:afiete/feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum _BookingStep { date, time, duration, type }

class BookSessionScreen extends StatefulWidget {
  final DoctorEntity doctor;

  const BookSessionScreen({super.key, required this.doctor});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  _BookingStep _step = _BookingStep.date;
  DateTime? _selectedDate;
  DateTime? _selectedTime;
  int? _selectedDurationSlots;
  String? _selectedSessionType;
  bool _isSubmitting = false;

  List<DateTime> get _sortedAvailableTimes {
    final now = DateTime.now();
    final list =
        widget.doctor.availableTimes.where((time) => time.isAfter(now)).toList()
          ..sort((a, b) => a.compareTo(b));
    return list;
  }

  List<DateTime> get _availableDays {
    final unique = <DateTime>[];
    for (final time in _sortedAvailableTimes) {
      final day = DateUtils.dateOnly(time);
      if (!unique.any((item) => DateUtils.isSameDay(item, day))) {
        unique.add(day);
      }
    }
    return unique;
  }

  List<DateTime> get _timesForSelectedDay {
    if (_selectedDate == null) {
      return const [];
    }
    return _sortedAvailableTimes
        .where((time) => DateUtils.isSameDay(time, _selectedDate))
        .toList();
  }

  List<int> get _availableDurations {
    if (widget.doctor.availableDurations.isEmpty) {
      return const [1, 2];
    }
    final durations =
        widget.doctor.availableDurations.where((e) => e > 0).toList()..sort();
    return durations.isEmpty ? const [1, 2] : durations;
  }

  List<String> get _availableSessionTypes {
    if (widget.doctor.availableSessionTypes.isEmpty) {
      return SessionType.all;
    }
    final supported = widget.doctor.availableSessionTypes
        .where((e) => SessionType.all.contains(e))
        .toList();
    return supported.isEmpty ? SessionType.all : supported;
  }

  @override
  void initState() {
    super.initState();
    final days = _availableDays;
    if (days.isNotEmpty) {
      _selectedDate = days.first;
    }
  }

  bool get _canContinue {
    switch (_step) {
      case _BookingStep.date:
        return _selectedDate != null;
      case _BookingStep.time:
        return _selectedTime != null;
      case _BookingStep.duration:
        return _selectedDurationSlots != null;
      case _BookingStep.type:
        return _selectedSessionType != null && !_isSubmitting;
    }
  }

  Future<void> _onContinuePressed() async {
    switch (_step) {
      case _BookingStep.date:
        setState(() => _step = _BookingStep.time);
        return;
      case _BookingStep.time:
        setState(() => _step = _BookingStep.duration);
        return;
      case _BookingStep.duration:
        setState(() => _step = _BookingStep.type);
        return;
      case _BookingStep.type:
        await _submitBooking();
        return;
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedTime == null ||
        _selectedDurationSlots == null ||
        _selectedSessionType == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    final authState = context.read<AuthCubit>().state;
    String patientId = 'unknown-patient';
    if (authState is AuthLoaded) {
      patientId = authState.user.id;
    } else if (authState is AuthProfileUpdated) {
      patientId = authState.user.id;
    }

    final cubit = context.read<AppointmentsCubit>();
    await cubit.createBookingDraft(
      doctorId: widget.doctor.id,
      patientId: patientId,
      doctorName: widget.doctor.name,
      scheduledAt: _selectedTime!,
      durationSlots: _selectedDurationSlots!,
      consultationFee: widget.doctor.consultationFee,
      sessionType: _selectedSessionType!,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    final state = cubit.state;
    if (state is AppointmentsError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking draft created successfully.')),
    );
    final amount = widget.doctor.consultationFee.getFeeBySType(
      _selectedSessionType!,
    );

    Navigator.pushNamed(
      context,
      MyRoutes.paymentScreen,
      arguments: PaymentRequestEntity(
        doctorId: widget.doctor.id,
        patientId: patientId,
        doctorName: widget.doctor.name,
        scheduledAt: _selectedTime!,
        durationSlots: _selectedDurationSlots!,
        sessionType: _selectedSessionType!,
        amount: amount,
        currency: 'USD',
        method: PaymentMethod.card,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canBook = _availableDays.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Session', style: AppStyles.headingMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_titleForStep(_step), style: AppStyles.headingMedium),
            const SizedBox(height: 6),
            if (_step == _BookingStep.time && _selectedDate != null)
              Text(
                DateFormat('EEE, dd MMM yyyy').format(_selectedDate!),
                style: AppStyles.bodySmall,
              ),
            const SizedBox(height: 14),
            Expanded(
              child: !canBook
                  ? _buildNoAvailabilityView()
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _buildStepContent(),
                    ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              widget: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      _step == _BookingStep.type
                          ? 'Continue to payment'
                          : 'Continue',
                      style: AppStyles.headingSmall.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
              onPressed: (_canContinue && canBook) ? _onContinuePressed : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case _BookingStep.date:
        return _buildDateStep();
      case _BookingStep.time:
        return _buildTimeStep();
      case _BookingStep.duration:
        return _buildDurationStep();
      case _BookingStep.type:
        return _buildTypeStep();
    }
  }

  Widget _buildDateStep() {
    return ListView.separated(
      key: const ValueKey('date-step'),
      itemCount: _availableDays.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final day = _availableDays[index];
        final isSelected =
            _selectedDate != null && DateUtils.isSameDay(_selectedDate, day);
        return _OptionCard(
          title: DateFormat('EEEE, dd MMM yyyy').format(day),
          subtitle: 'Available from database',
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedDate = day;
              _selectedTime = null;
            });
          },
        );
      },
    );
  }

  Widget _buildTimeStep() {
    final times = _timesForSelectedDay;
    if (times.isEmpty) {
      return const Center(
        key: ValueKey('time-step-empty'),
        child: Text('No available times for this date.'),
      );
    }

    return GridView.builder(
      key: const ValueKey('time-step'),
      itemCount: times.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final time = times[index];
        final isSelected = _selectedTime != null && _selectedTime == time;
        return _ChipCard(
          label: DateFormat('h:mm a').format(time).toLowerCase(),
          isSelected: isSelected,
          onTap: () => setState(() => _selectedTime = time),
        );
      },
    );
  }

  Widget _buildDurationStep() {
    return ListView.separated(
      key: const ValueKey('duration-step'),
      itemCount: _availableDurations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final slots = _availableDurations[index];
        final minutes = slots * 30;
        final isSelected = _selectedDurationSlots == slots;
        return _OptionCard(
          title: '$minutes min',
          subtitle: 'Defined by provider availability',
          isSelected: isSelected,
          onTap: () => setState(() => _selectedDurationSlots = slots),
          leading: Icons.schedule,
        );
      },
    );
  }

  Widget _buildTypeStep() {
    return ListView.separated(
      key: const ValueKey('type-step'),
      itemCount: _availableSessionTypes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final type = _availableSessionTypes[index];
        final isSelected = _selectedSessionType == type;
        final fee = widget.doctor.consultationFee.getFeeBySType(type);
        return _OptionCard(
          title: SessionType.displayName(type),
          subtitle: fee > 0
              ? '\$${fee.toStringAsFixed(2)} per session'
              : 'Available',
          isSelected: isSelected,
          onTap: () => setState(() => _selectedSessionType = type),
          leading: SessionType.icon(type),
        );
      },
    );
  }

  Widget _buildNoAvailabilityView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 10),
            Text(
              'This doctor has no available schedule loaded from the database yet.',
              textAlign: TextAlign.center,
              style: AppStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _titleForStep(_BookingStep step) {
    switch (step) {
      case _BookingStep.date:
        return 'Choose day';
      case _BookingStep.time:
        return 'Choose time';
      case _BookingStep.duration:
        return 'Choose session duration';
      case _BookingStep.type:
        return 'Choose session type';
    }
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? leading;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Icon(leading, color: colorScheme.primary),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.circle,
              color: isSelected ? colorScheme.primary : theme.cardColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.primaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.55),
          ),
        ),
        child: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
