import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/create_appointment_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/get_appointments_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final CreateAppointmentUseCase createAppointmentDraftUseCase;

  AppointmentsCubit(
    this.getAppointmentsUseCase,
    this.createAppointmentDraftUseCase,
  ) : super(const AppointmentsInitial());

  Future<void> loadAppointments() async {
    emit(const AppointmentsLoading());
    final result = await getAppointmentsUseCase(NoParams());
    result.fold(
      (failure) => emit(AppointmentsError(failure.errorMessage)),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  Future<void> createBookingDraft({
    required String doctorId,
    required String patientId,
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
  }) async {
    final result = await createAppointmentDraftUseCase(
      CreateAppointmentParams(
        doctorId: doctorId,
        patientId: patientId,
        doctorName: doctorName,
        scheduledAt: scheduledAt,
        durationSlots: durationSlots,
        consultationFee: consultationFee,
        sessionType: sessionType,
      ),
    );

    result.fold((failure) => emit(AppointmentsError(failure.errorMessage)), (
      created,
    ) {
      final currentState = state;
      if (currentState is AppointmentsLoaded) {
        final updated = [created, ...currentState.appointments]
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        emit(AppointmentsLoaded(updated));
      } else {
        emit(AppointmentsLoaded([created]));
      }
    });
  }
}
