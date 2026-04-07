part of 'sessions_cubit.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object> get props => [];
}

class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

class UpcomingSessionsLoaded extends SessionsState {
  final List<SessionEntity> sessions;

  const UpcomingSessionsLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class PastSessionsLoaded extends SessionsState {
  final List<SessionEntity> sessions;

  const PastSessionsLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);

  @override
  List<Object> get props => [message];
}

class ReviewSubmitted extends SessionsState {
  const ReviewSubmitted();
}
