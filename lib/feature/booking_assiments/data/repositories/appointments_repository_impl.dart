import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_remote_datasource.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource dataSource;

  const AppointmentsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments() async {
    try {
      final result = await dataSource.getAppointments();
      return Right<Failure, List<AppointmentEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<AppointmentEntity>>(
        ServerFailure.fromDioError(e),
      );
    } catch (_) {
      return Left<Failure, List<AppointmentEntity>>(
        ServerFailure('Unable to load appointments right now.'),
      );
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
    required String doctorId,
    required String patientId,
  }) async {
    try {
      final result = await dataSource.createAppointment(
        doctorId: doctorId,
        patientId: patientId,
        doctorName: doctorName,
        scheduledAt: scheduledAt,
        durationSlots: durationSlots,
        consultationFee: consultationFee,
        sessionType: sessionType,
      );
      return Right<Failure, AppointmentEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, AppointmentEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, AppointmentEntity>(
        ServerFailure('Could not create booking draft. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    try {
      await dataSource.cancelAppointment(appointmentId);
      return Right<Failure, void>(null);
    } on DioException catch (e) {
      return Left<Failure, void>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, void>(
        ServerFailure('Could not cancel appointment.'),
      );
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newScheduledAt,
  }) async {
    try {
      final result = await dataSource.rescheduleAppointment(
        appointmentId: appointmentId,
        newScheduledAt: newScheduledAt,
      );
      return Right<Failure, AppointmentEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, AppointmentEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, AppointmentEntity>(
        ServerFailure('Could not reschedule appointment.'),
      );
    }
  }
}
