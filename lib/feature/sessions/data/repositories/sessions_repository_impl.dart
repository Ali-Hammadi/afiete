import 'dart:core';

import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/sessions/data/datasources/sessions_remote_datasource.dart';
import 'package:afiete/feature/sessions/domain/entities/review_entity.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:afiete/feature/sessions/domain/repositories/sessions_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsRemoteDataSource dataSource;

  const SessionsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SessionEntity>>> getUpcomingSessions() async {
    try {
      final result = await dataSource.getUpcomingSessions();
      return Right<Failure, List<SessionEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<SessionEntity>>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, List<SessionEntity>>(
        ServerFailure('Unable to load upcoming sessions.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SessionEntity>>> getPastSessions() async {
    try {
      final result = await dataSource.getPastSessions();
      return Right<Failure, List<SessionEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<SessionEntity>>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, List<SessionEntity>>(
        ServerFailure('Unable to load past sessions.'),
      );
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> joinSession(String sessionId) async {
    try {
      final result = await dataSource.joinSession(sessionId);
      return Right<Failure, SessionEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, SessionEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, SessionEntity>(
        ServerFailure('Could not join session.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelSession(String sessionId) async {
    try {
      await dataSource.cancelSession(sessionId);
      return Right<Failure, void>(null);
    } on DioException catch (e) {
      return Left<Failure, void>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, void>(ServerFailure('Could not cancel session.'));
    }
  }

  @override
  Future<Either<Failure, SessionEntity>> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  }) async {
    try {
      final result = await dataSource.rescheduleSession(
        sessionId: sessionId,
        newScheduledAt: newScheduledAt,
      );
      return Right<Failure, SessionEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, SessionEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, SessionEntity>(
        ServerFailure('Could not reschedule session.'),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await dataSource.addReview(
        sessionId: sessionId,
        rating: rating,
        comment: comment,
      );
      return Right<Failure, ReviewEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, ReviewEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, ReviewEntity>(
        ServerFailure('Could not submit review.'),
      );
    }
  }
}
