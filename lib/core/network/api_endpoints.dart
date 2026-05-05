abstract class ApiEndpoints {
  static const String api = '/api';

  static const String auth = '/api';
  static const String doctors = '/api/doctors';
  static const String articles = '/api/articles';
  // Swagger shows "appointmetns" (historic typo) — keep as primary to match server
  static const String appointments = '$api/appointmetns';
  // Legacy/alternate spelling preserved for local compat
  static const String appointmentsLegacy = '/api/appointments';
  static const String sessions = '/api/sessions';
  static const String settings = '/api/settings';
  static const String assignments = '/api/assignments';
  static const String reports = '/api/reports';
  static const String voice = '/voice';
  static const String video = '/video';
  static const String users = '$api/users';
  static const String patients = '$api/patients';
  static const String token = '$api/token';

  static const String login = '$users/login/';
  static const String signup = '$patients/register/';
  static const String logout = '$auth/logout';
  static const String deleteAccount = '$users/account/delete/';
  static const String googleLogin = '$patients/google/auth/';
  static const String updateProfile = '$patients/profile/';

  static const String requestEmailChangeOtp = '$users/otp/resend';
  static const String confirmEmailChange = '$users/otp/verify';

  static const String requestEmailChange = '$users/email/reset';
  static const String confirmEmailChangeNew = '$users/email-change/confirm';
  static const String changePassword = '$users/password/change/';
  static const String resetPassword = '$users/password/reset';
  static const String tokenObtainPair = '$token/';
  static const String tokenRefresh = '$token/refresh/';
  static const String tokenVerify = '$token/verify/';

  // Assessments (per Swagger)
  static const String assessmentsForm = '$api/assessments/form/';
  static const String assessmentsFormSubmit = '$api/assessments/form/submit/';

  // Users auth endpoints (per Swagger)
  static const String usersForgotPassword = '$users/auth/forgot-password/';
  static const String usersAuthResetPassword = '$users/auth/reset-password/';
  static const String usersAuthVerifyOtp = '$users/auth/verify-otp/';
  static const String usersEmailResetPut = '$users/email/reset/';
  static const String usersEmailResetPatch = '$users/email/reset/';
  static const String usersOtpResend = '$users/otp/resend/';
  static const String usersOtpVerify = '$users/otp/verify/';
  static const String usersPasswordResetPut = '$users/password/reset/';
  static const String usersPasswordResetPatch = '$users/password/reset/';

  // Auth request keys
  static const String keyEmail = 'email';
  static const String keyPassword = 'password';
  static const String keyCurrentPassword = 'current_password';
  static const String keyNewPassword = 'new_password';
  static const String keyOtp = 'otp';
  static const String keyIdToken = 'id_token';

  static const String allDoctors = doctors;
  static String doctorById(String id) => '$doctors/$id';
  static const String doctorRegister = '$doctors/register/';
  // Align with Swagger paths: profile update at /doctors/profile/
  static const String doctorProfileUpdate = '$doctors/profile/';
  // Education endpoints per Swagger: add via /doctors/education/add
  static const String doctorEducationAdd = '$doctors/education/add';
  static String doctorEducationById(String id) => '$doctors/education/$id/';
  // Doctor schedule endpoints (per Swagger)
  static const String doctorScheduleList = '$doctors/schedule/';
  static const String doctorScheduleCreate = '$doctors/schedule/';
  static String doctorScheduleById(String id) => '$doctors/schedule/$id/';
  static String doctorScheduleUpdate(String id) => '$doctors/schedule/$id/';
  static String doctorScheduleDelete(String id) => '$doctors/schedule/$id/';
  // Appointments -> doctors prices under the "appointmetns" base (Swagger)
  static const String appointmentsDoctorsPrices =
      '$appointments/dcotors/prices/';
  static String appointmentsDoctorsPricesByType(String type) =>
      '$appointments/dcotors/prices/$type/';

  // Articles endpoints
  static const String allArticles = '$articles/';
  static String articleById(String id) => '$articles/$id/';
  static String articlesByDoctor(String doctorId) =>
      '$doctors/$doctorId/articles/';
  static String articleLike(String articleId) => '$articles/$articleId/like/';
  static String articleDislike(String articleId) =>
      '$articles/$articleId/dislike/';

  // Articles query/body keys for doctor linkage and filtering
  static const String keyDoctor = 'doctor';
  static const String keyDoctorId = 'doctor_id';
  static const String keyUserDiagnosis = 'user_diagnosis';
  static const String keyRelatedConditions = 'related_conditions';
  static const String keyPage = 'page';
  static const String keyPageSize = 'page_size';

  static const String appointmentsList = '$appointments/list';
  static const String appointmentsCreate = '$appointments/create';
  static const String appointmentsCancel = '$appointments/cancel';
  static const String appointmentsReschedule = '$appointments/reschedule';

  static const String sessionsUpcoming = '$sessions/upcoming';
  static const String sessionsPast = '$sessions/past';
  static const String sessionsJoin = '$sessions/join';
  static const String sessionsCancel = '$sessions/cancel';
  static const String sessionsReschedule = '$sessions/reschedule';
  static const String sessionsReview = '$sessions/review';

  static const String settingsMedicalProfile = '$settings/medical-profile';
  static const String settingsMedicalProfileNotes =
      '$settings/medical-profile/notes';
  static const String settingsMedicalProfileNotesShare =
      '$settings/medical-profile/notes/share';
  static const String settingsReports = '$settings/reports';

  static const String assignmentQuestions = '$assignments/questions';
  static const String assignmentSubmit = '$assignments/submit';

  static const String reportsSubmit = '$reports/submit';
  static const String reportsHistory = '$reports/history';
  static const String reportsByType = '$reports/by-type';

  static const String voiceCalls = '$voice/calls';
  static const String voiceCallsStart = '$voice/calls/start';
  static String voiceCallsEnd(String callId) => '$voice/calls/$callId/end';

  static const String videoCalls = '$video/calls';
  static const String videoCallsStart = '$video/calls/start';
  static String videoCallsEnd(String callId) => '$video/calls/$callId/end';
}
