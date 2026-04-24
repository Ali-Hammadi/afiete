import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';
import 'package:afiete/feature/sessions/data/models/review_model.dart';
import 'package:afiete/feature/sessions/data/datasources/sessions_remote_datasource.dart';
import 'package:afiete/feature/sessions/data/models/session_model.dart';

class SessionsMockDataSourceImpl implements SessionsRemoteDataSource {
  final List<Map<String, dynamic>> _doctorNotifications = [];

  final List<SessionModel> _upcomingSessions = [
    SessionModel(
      id: 'session_1',
      doctorId: 'doc_1',
      doctorName: _localized('Dr. Ahmed Ali', 'د. أحمد علي'),
      doctorSpecialization: _localized('Psychologist', 'أخصائي نفسي'),
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
      doctorName: _localized('Dr. Sara Ahmed', 'د. سارة أحمد'),
      doctorSpecialization: _localized('Therapist', 'معالجة نفسية'),
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
    final session = _findSession(sessionId);
    if (session != null) {
      _recordDoctorNotification(
        doctorId: session.doctorId,
        sessionId: session.id,
        type: 'cancelled',
        message: _localized(
          'The patient cancelled the session.',
          'قام المريض بإلغاء الجلسة.',
        ),
      );
    }
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
      final doctor = MockDoctorsData.getMockDoctorById(session.doctorId);
      final availableTimes = doctor == null
          ? <DateTime>[]
          : List<DateTime>.from(
              (doctor['availableTimes'] as List<dynamic>? ?? const []).map(
                (time) => DateTime.parse(time.toString()),
              ),
            );
      final chosenTime = _pickBestRescheduleTime(
        doctorId: session.doctorId,
        currentSessionId: session.id,
        requestedTime: newScheduledAt,
        availableTimes: availableTimes,
      );
      final doctorName = doctor == null
          ? session.doctorName
          : _localized(
              doctor['name'].toString(),
              doctor['nameAr']?.toString() ?? doctor['name'].toString(),
            );
      final specialization = doctor == null
          ? session.doctorSpecialization
          : _localized(
              doctor['specializationLabel']?.toString() ??
                  session.doctorSpecialization,
              doctor['specializationLabelAr']?.toString() ??
                  session.doctorSpecialization,
            );
      final rescheduled = SessionModel(
        id: session.id,
        doctorId: session.doctorId,
        doctorName: doctorName,
        doctorSpecialization: specialization,
        doctorImageUrl: session.doctorImageUrl,
        scheduledAt: chosenTime,
        durationMinutes: session.durationMinutes,
        sessionType: session.sessionType,
        status: 'rescheduled',
        isUpcoming: true,
      );
      _upcomingSessions[index] = rescheduled;
      _recordDoctorNotification(
        doctorId: session.doctorId,
        sessionId: session.id,
        type: 'rescheduled',
        message: _localized(
          'The session was rescheduled to ${chosenTime.toIso8601String()}.',
          'تمت إعادة جدولة الجلسة إلى ${chosenTime.toIso8601String()}.',
        ),
      );
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

  SessionModel? _findSession(String sessionId) {
    for (final session in _upcomingSessions) {
      if (session.id == sessionId) {
        return session;
      }
    }
    for (final session in _pastSessions) {
      if (session.id == sessionId) {
        return session;
      }
    }
    return null;
  }

  DateTime _pickBestRescheduleTime({
    required String doctorId,
    required String currentSessionId,
    required DateTime requestedTime,
    required List<DateTime> availableTimes,
  }) {
    final now = DateTime.now();
    final conflictingTimes = _upcomingSessions
        .where(
          (session) =>
              session.id != currentSessionId && session.doctorId == doctorId,
        )
        .map((session) => session.scheduledAt)
        .toSet();

    final futureOptions =
        availableTimes
            .where(
              (time) => time.isAfter(now) && !conflictingTimes.contains(time),
            )
            .toList()
          ..sort();

    for (final option in futureOptions) {
      if (option.isAfter(requestedTime) && !conflictingTimes.contains(option)) {
        return option;
      }
    }

    if (futureOptions.isNotEmpty) {
      return futureOptions.first;
    }

    return requestedTime.isAfter(now)
        ? requestedTime
        : now.add(const Duration(days: 1));
  }

  void _recordDoctorNotification({
    required String doctorId,
    required String sessionId,
    required String type,
    required String message,
  }) {
    _doctorNotifications.add({
      'doctorId': doctorId,
      'sessionId': sessionId,
      'type': type,
      'message': message,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static String _localized(String en, String ar) =>
      SettingsStrings.isArabic ? ar : en;
}
