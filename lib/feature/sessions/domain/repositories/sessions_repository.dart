import 'dart:core';

import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/sessions/domain/entities/review_entity.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SessionsRepository {
  Future<Either<Failure, List<SessionEntity>>> getUpcomingSessions();

  Future<Either<Failure, List<SessionEntity>>> getPastSessions();

  Future<Either<Failure, SessionEntity>> joinSession(String sessionId);

  Future<Either<Failure, void>> cancelSession(String sessionId);

  Future<Either<Failure, SessionEntity>> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  });

  Future<Either<Failure, ReviewEntity>> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  });
}
