abstract class ApiEndpoints {
  static const String auth = '/api/auth';
  static const String doctors = '/api/doctors';
  static const String appointments = '/api/appointments';
  static const String sessions = '/api/sessions';
  static const String settings = '/api/settings';
  static const String assignments = '/api/assignments';
  static const String reports = '/api/reports';

  static const String login = '$auth/login';
  static const String signup = '$auth/signup';
  static const String logout = '$auth/logout';
  static const String deleteAccount = '$auth/delete-account';
  static const String googleLogin = '$auth/google-login';

  static const String allDoctors = doctors;
  static String doctorById(String id) => '$doctors/$id';

  static const String appointmentsList = '$appointments/list';
  static const String appointmentsCreate = '$appointments/create';

  static const String sessionsUpcoming = '$sessions/upcoming';
  static const String sessionsPast = '$sessions/past';
  static const String sessionsJoin = '$sessions/join';
  static const String sessionsCancel = '$sessions/cancel';
  static const String sessionsReschedule = '$sessions/reschedule';
  static const String sessionsReview = '$sessions/review';

  static const String settingsMedicalProfile = '$settings/medical-profile';
  static const String settingsReports = '$settings/reports';

  static const String assignmentQuestions = '$assignments/questions';
  static const String assignmentSubmit = '$assignments/submit';

  static const String reportsSubmit = '$reports/submit';
  static const String reportsHistory = '$reports/history';
  static const String reportsByType = '$reports/by-type';
}
