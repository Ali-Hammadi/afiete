import 'package:afiete/feature/sessions/data/models/review_model.dart';
import 'package:afiete/feature/sessions/data/models/session_model.dart';

abstract class SessionsMockDataSource {
  Future<List<SessionModel>> getUpcomingSessions();

  Future<List<SessionModel>> getPastSessions();

  Future<SessionModel> joinSession(String sessionId);

  Future<void> cancelSession(String sessionId);

  Future<SessionModel> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  });

  Future<ReviewModel> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  });
}

class SessionsMockDataSourceImpl implements SessionsMockDataSource {
  final List<SessionModel> _upcomingSessions = [
    SessionModel(
      id: 'session_1',
      doctorId: 'doc_1',
      doctorName: 'Dr. Ahmed Ali',
      doctorSpecialization: 'Psychologist',
      doctorImageUrl: null,
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      durationMinutes: 30,
      sessionType: 'video_call',
      status: 'confirmed',
      isUpcoming: true,
    ),
  ];

  final List<SessionModel> _pastSessions = [
    SessionModel(
      id: 'session_101',
      doctorId: 'doc_2',
      doctorName: 'Dr. Sara Ahmed',
      doctorSpecialization: 'Therapist',
      doctorImageUrl: null,
      scheduledAt: DateTime.now().subtract(const Duration(days: 8)),
      durationMinutes: 30,
      sessionType: 'in_clinic',
      status: 'completed',
      isUpcoming: false,
    ),
  ];

  @override
  Future<List<SessionModel>> getUpcomingSessions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<SessionModel>.from(_upcomingSessions)
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<List<SessionModel>> getPastSessions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<SessionModel>.from(_pastSessions)
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  }

  @override
  Future<SessionModel> joinSession(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final session = _upcomingSessions.firstWhere((s) => s.id == sessionId);
    return session;
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _upcomingSessions.removeWhere((s) => s.id == sessionId);
  }

  @override
  Future<SessionModel> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _upcomingSessions.indexWhere((s) => s.id == sessionId);
    if (index >= 0) {
      final session = _upcomingSessions[index];
      final rescheduled = SessionModel(
        id: session.id,
        doctorId: session.doctorId,
        doctorName: session.doctorName,
        doctorSpecialization: session.doctorSpecialization,
        doctorImageUrl: session.doctorImageUrl,
        scheduledAt: newScheduledAt,
        durationMinutes: session.durationMinutes,
        sessionType: session.sessionType,
        status: 'rescheduled',
        isUpcoming: true,
      );
      _upcomingSessions[index] = rescheduled;
      return rescheduled;
    }
    throw Exception('Session not found');
  }

  @override
  Future<ReviewModel> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ReviewModel(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
  }
}
