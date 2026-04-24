import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:afiete/feature/sessions/domain/usecase/add_review_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/cancel_session_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_past_sessions_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_upcoming_sessions_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/reschedule_session_usecase.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final GetUpcomingSessionsUseCase getUpcomingSessionsUseCase;
  final GetPastSessionsUseCase getPastSessionsUseCase;
  final CancelSessionUseCase cancelSessionUseCase;
  final RescheduleSessionUseCase rescheduleSessionUseCase;
  final AddReviewUseCase addReviewUseCase;

  SessionsCubit(
    this.getUpcomingSessionsUseCase,
    this.getPastSessionsUseCase,
    this.cancelSessionUseCase,
    this.rescheduleSessionUseCase,
    this.addReviewUseCase,
  ) : super(const SessionsInitial());

  Future<void> loadUpcomingSessions() async {
    emit(const SessionsLoading());
    final result = await getUpcomingSessionsUseCase(NoParams());
    result.fold(
      (failure) => emit(SessionsError(failure.errorMessage)),
      (sessions) => emit(UpcomingSessionsLoaded(sessions)),
    );
  }

  Future<void> loadPastSessions() async {
    emit(const SessionsLoading());
    final result = await getPastSessionsUseCase(NoParams());
    result.fold(
      (failure) => emit(SessionsError(failure.errorMessage)),
      (sessions) => emit(PastSessionsLoaded(sessions)),
    );
  }

  Future<bool> cancelSession({
    required String sessionId,
    required String doctorId,
  }) async {
    final result = await cancelSessionUseCase(
      CancelSessionParams(sessionId: sessionId, doctorId: doctorId),
    );
    return result.fold<Future<bool>>(
      (failure) {
        emit(SessionsError(failure.errorMessage));
        return Future.value(false);
      },
      (_) async {
        await loadUpcomingSessions();
        return true;
      },
    );
  }

  Future<bool> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  }) async {
    final result = await rescheduleSessionUseCase(
      RescheduleSessionParams(
        sessionId: sessionId,
        newScheduledAt: newScheduledAt,
      ),
    );

    return result.fold<Future<bool>>(
      (failure) {
        emit(SessionsError(failure.errorMessage));
        return Future.value(false);
      },
      (_) async {
        await loadUpcomingSessions();
        return true;
      },
    );
  }

  Future<void> submitReview({
    required String sessionId,
    required String doctorId,
    required int rating,
    required String comment,
  }) async {
    final result = await addReviewUseCase(
      AddReviewParams(sessionId: sessionId, rating: rating, comment: comment),
    );
    result.fold((failure) => emit(SessionsError(failure.errorMessage)), (_) {
      MockDoctorsData.addMockDoctorReview(
        doctorId: doctorId,
        rating: rating,
        review: comment,
      );
      emit(const ReviewSubmitted());
    });
  }
}
