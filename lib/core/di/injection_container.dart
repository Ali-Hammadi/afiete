import 'package:afiete/core/network/dio_factory.dart';
import 'package:afiete/feature/assignments/data/datasources/assignments_mock_datasource.dart';
import 'package:afiete/feature/assignments/data/datasources/assignments_remote_datasource.dart';
import 'package:afiete/feature/assignments/data/repositories/assignments_repository_impl.dart';
import 'package:afiete/feature/assignments/domain/repositories/assignments_repository.dart';
import 'package:afiete/feature/assignments/domain/usecase/get_assignment_questions_usecase.dart';
import 'package:afiete/feature/assignments/domain/usecase/submit_assignment_usecase.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/confirm_email_change_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/google_signin_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/request_email_change_otp_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/update_profile_info_usecase.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_mock_datasource.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_remote_datasource.dart';
import 'package:afiete/feature/booking_assiments/data/repositories/appointments_repository_impl.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/cancel_appointment_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/create_appointment_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/get_appointments_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/reschedule_appointment_usecase.dart';
import 'package:afiete/feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'package:afiete/feature/chat/data/datasources/chat_mock_datasource.dart';
import 'package:afiete/feature/chat/data/datasources/chat_remote_datasource.dart';
import 'package:afiete/feature/chat/data/repositories/chat_repository_impl.dart';
import 'package:afiete/feature/chat/domain/repositories/chat_repository.dart';
import 'package:afiete/feature/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:afiete/feature/chat/domain/usecases/mark_chat_message_read_usecase.dart';
import 'package:afiete/feature/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:afiete/feature/doctors/data/datasources/doctors_mock_datasource.dart';
import 'package:afiete/feature/doctors/data/datasources/doctors_remote_datasource.dart';
import 'package:afiete/feature/doctors/data/repositories/doctors_repository_impl.dart';
import 'package:afiete/feature/doctors/domain/repositories/doctors_repository.dart';
import 'package:afiete/feature/doctors/domain/usecase/get_doctors_usecase.dart';
import 'package:afiete/feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:afiete/feature/feeling/data/datasources/feeling_local_data_source.dart';
import 'package:afiete/feature/feeling/data/repositories/feeling_repository_impl.dart';
import 'package:afiete/feature/feeling/domain/repositories/feeling_repository.dart';
import 'package:afiete/feature/feeling/domain/usecase/feeling_usecases.dart';
import 'package:afiete/feature/feeling/presentation/cubit/feeling_cubit.dart';
import 'package:afiete/feature/relax/data/datasources/music_local_data_source.dart';
import 'package:afiete/feature/relax/data/repositories/music_repository_impl.dart';
import 'package:afiete/feature/relax/domain/repositories/music_repository.dart';
import 'package:afiete/feature/relax/domain/usecase/get_recommended_music_usecase.dart';
import 'package:afiete/feature/relax/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/payment/data/datasources/payment_mock_datasource.dart';
import 'package:afiete/feature/payment/data/datasources/payment_remote_datasource.dart';
import 'package:afiete/feature/payment/data/repositories/payment_repository_impl.dart';
import 'package:afiete/feature/payment/domain/repositories/payment_repository.dart';
import 'package:afiete/feature/payment/domain/usecases/process_payment_usecase.dart';
import 'package:afiete/feature/payment/presentation/cubit/payment_cubit.dart';
import 'package:afiete/feature/sessions/data/datasources/sessions_mock_datasource.dart';
import 'package:afiete/feature/sessions/data/datasources/sessions_remote_datasource.dart';
import 'package:afiete/feature/sessions/data/repositories/sessions_repository_impl.dart';
import 'package:afiete/feature/sessions/domain/repositories/sessions_repository.dart';
import 'package:afiete/feature/sessions/domain/usecase/add_review_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/cancel_session_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_past_sessions_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_upcoming_sessions_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/reschedule_session_usecase.dart';
import 'package:afiete/feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'package:afiete/feature/settings/data/data_source/settings_remote_data_source.dart';
import 'package:afiete/feature/settings/data/data_source/settings_mock_data_source.dart';
import 'package:afiete/feature/settings/data/repositories/settings_repository_impl.dart';
import 'package:afiete/feature/settings/domin/repositories/settings_repository.dart';
import 'package:afiete/feature/settings/domin/usecase/get_medical_profile_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/share_medical_note_with_doctor_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/submit_report_issue_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/update_medical_note_usecase.dart';
import 'package:afiete/feature/settings/presentation/cubits/settings_cubit.dart';
import 'package:afiete/feature/video/data/datasources/video_mock_datasource.dart';
import 'package:afiete/feature/video/data/datasources/video_remote_datasource.dart';
import 'package:afiete/feature/video/data/repositories/video_repository_impl.dart';
import 'package:afiete/feature/video/domain/repositories/video_repository.dart';
import 'package:afiete/feature/video/domain/usecase/end_video_call_usecase.dart';
import 'package:afiete/feature/video/domain/usecase/get_video_calls_usecase.dart';
import 'package:afiete/feature/video/domain/usecase/start_video_call_usecase.dart';
import 'package:afiete/feature/voice/data/datasources/voice_mock_datasource.dart';
import 'package:afiete/feature/voice/data/datasources/voice_remote_datasource.dart';
import 'package:afiete/feature/voice/data/repositories/voice_repository_impl.dart';
import 'package:afiete/feature/voice/domain/repositories/voice_repository.dart';
import 'package:afiete/feature/voice/domain/usecase/end_voice_call_usecase.dart';
import 'package:afiete/feature/voice/domain/usecase/get_voice_calls_usecase.dart';
import 'package:afiete/feature/voice/domain/usecase/start_voice_call_usecase.dart';
import 'package:afiete/feature/report/data/datasources/report_remote_datasource.dart';
import 'package:afiete/feature/report/data/repositories/report_repository_impl.dart';
import 'package:afiete/feature/report/domain/repositories/report_repository.dart';
import 'package:afiete/feature/report/domain/usecases/submit_report_usecase.dart';
import 'package:afiete/feature/report/domain/usecases/get_report_history_usecase.dart';
import 'package:afiete/feature/report/domain/usecases/get_reports_by_type_usecase.dart';
import 'package:afiete/feature/report/presentation/cubits/report_cubit.dart';
import 'package:afiete/feature/articles/data/datasources/articles_mock_datasource.dart';
import 'package:afiete/feature/articles/data/repositories/articles_repository_impl.dart';
import 'package:afiete/feature/articles/domain/repositories/articles_repository.dart';
import 'package:afiete/feature/articles/domain/usecases/articles_usecases.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:afiete/feature/auth/domain/usecase/login_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/signup_usecase.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;
const bool useMockDataSources = true;

Future<void> init() async {
  // Core network
  sl.registerLazySingleton<Dio>(() => DioFactory.create());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileInfoUseCase>(
    () => UpdateProfileInfoUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RequestEmailChangeOtpUseCase>(
    () => RequestEmailChangeOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ConfirmEmailChangeUseCase>(
    () => ConfirmEmailChangeUseCase(sl<AuthRepository>()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      sl<LoginUseCase>(),
      sl<SignupUseCase>(),
      sl<LogoutUseCase>(),
      sl<DeleteAccountUseCase>(),
      sl<GoogleSignInUseCase>(),
      sl<UpdateProfileInfoUseCase>(),
      sl<RequestEmailChangeOtpUseCase>(),
      sl<VerifyOtpUseCase>(),
      sl<ConfirmEmailChangeUseCase>(),
      sl<AuthRepository>(),
    ),
  );

  // Chat data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => useMockDataSources
        ? ChatMockDataSourceImpl()
        : ChatRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Chat repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(dataSource: sl<ChatRemoteDataSource>()),
  );

  // Chat use cases
  sl.registerLazySingleton<GetChatMessagesUseCase>(
    () => GetChatMessagesUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendChatMessageUseCase>(
    () => SendChatMessageUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<MarkChatMessageReadUseCase>(
    () => MarkChatMessageReadUseCase(sl<ChatRepository>()),
  );

  // Voice call data sources
  sl.registerLazySingleton<VoiceRemoteDataSource>(
    () => useMockDataSources
        ? VoiceMockDataSourceImpl()
        : VoiceRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Voice call repositories
  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(dataSource: sl<VoiceRemoteDataSource>()),
  );

  // Voice call use cases
  sl.registerLazySingleton<GetVoiceCallsUseCase>(
    () => GetVoiceCallsUseCase(sl<VoiceRepository>()),
  );
  sl.registerLazySingleton<StartVoiceCallUseCase>(
    () => StartVoiceCallUseCase(sl<VoiceRepository>()),
  );
  sl.registerLazySingleton<EndVoiceCallUseCase>(
    () => EndVoiceCallUseCase(sl<VoiceRepository>()),
  );

  // Video call data sources
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => useMockDataSources
        ? VideoMockDataSourceImpl()
        : VideoRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Video call repositories
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(dataSource: sl<VideoRemoteDataSource>()),
  );

  // Video call use cases
  sl.registerLazySingleton<GetVideoCallsUseCase>(
    () => GetVideoCallsUseCase(sl<VideoRepository>()),
  );
  sl.registerLazySingleton<StartVideoCallUseCase>(
    () => StartVideoCallUseCase(sl<VideoRepository>()),
  );
  sl.registerLazySingleton<EndVideoCallUseCase>(
    () => EndVideoCallUseCase(sl<VideoRepository>()),
  );

  // Booking assignments data sources
  sl.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => useMockDataSources
        ? AppointmentsMockDataSourceImpl()
        : AppointmentsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Booking assignments repositories
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(
      dataSource: sl<AppointmentsRemoteDataSource>(),
    ),
  );

  // Booking assignments use cases
  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton<CreateAppointmentUseCase>(
    () => CreateAppointmentUseCase(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton<RescheduleAppointmentUseCase>(
    () => RescheduleAppointmentUseCase(sl<AppointmentsRepository>()),
  );

  // Booking assignments cubits
  sl.registerFactory<AppointmentsCubit>(
    () => AppointmentsCubit(
      sl<GetAppointmentsUseCase>(),
      sl<CreateAppointmentUseCase>(),
      sl<GetAllDoctorsUseCase>(),
      sl<CancelAppointmentUseCase>(),
      sl<RescheduleAppointmentUseCase>(),
    ),
  );

  // Payment data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => useMockDataSources
        ? PaymentMockDataSourceImpl()
        : PaymentRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Payment repositories
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(dataSource: sl<PaymentRemoteDataSource>()),
  );

  // Payment use cases
  sl.registerLazySingleton<ProcessPaymentUseCase>(
    () => ProcessPaymentUseCase(sl<PaymentRepository>()),
  );

  // Payment cubits
  sl.registerFactory<PaymentCubit>(
    () => PaymentCubit(sl<ProcessPaymentUseCase>()),
  );

  // Sessions data sources
  sl.registerLazySingleton<SessionsRemoteDataSource>(
    () => useMockDataSources
        ? SessionsMockDataSourceImpl()
        : SessionsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Sessions repositories
  sl.registerLazySingleton<SessionsRepository>(
    () => SessionsRepositoryImpl(dataSource: sl<SessionsRemoteDataSource>()),
  );

  // Sessions use cases
  sl.registerLazySingleton<GetUpcomingSessionsUseCase>(
    () => GetUpcomingSessionsUseCase(sl<SessionsRepository>()),
  );
  sl.registerLazySingleton<GetPastSessionsUseCase>(
    () => GetPastSessionsUseCase(sl<SessionsRepository>()),
  );
  sl.registerLazySingleton<CancelSessionUseCase>(
    () => CancelSessionUseCase(sl<SessionsRepository>()),
  );
  sl.registerLazySingleton<RescheduleSessionUseCase>(
    () => RescheduleSessionUseCase(sl<SessionsRepository>()),
  );
  sl.registerLazySingleton<AddReviewUseCase>(
    () => AddReviewUseCase(sl<SessionsRepository>()),
  );

  // Sessions cubits
  sl.registerFactory<SessionsCubit>(
    () => SessionsCubit(
      sl<GetUpcomingSessionsUseCase>(),
      sl<GetPastSessionsUseCase>(),
      sl<CancelSessionUseCase>(),
      sl<RescheduleSessionUseCase>(),
      sl<AddReviewUseCase>(),
    ),
  );

  // Doctors data sources
  sl.registerLazySingleton<DoctorsRemoteDataSource>(
    () => useMockDataSources
        ? DoctorsMockDataSourceImpl()
        : DoctorsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Doctors repositories
  sl.registerLazySingleton<DoctorsRepository>(
    () =>
        DoctorsRepositoryImpl(remoteDataSource: sl<DoctorsRemoteDataSource>()),
  );

  // Doctors use cases
  sl.registerLazySingleton<GetAllDoctorsUseCase>(
    () => GetAllDoctorsUseCase(sl<DoctorsRepository>()),
  );
  sl.registerLazySingleton<GetDoctorsBySpecialtyUseCase>(
    () => GetDoctorsBySpecialtyUseCase(sl<DoctorsRepository>()),
  );
  sl.registerLazySingleton<GetDoctorByIdUseCase>(
    () => GetDoctorByIdUseCase(sl<DoctorsRepository>()),
  );

  // Feeling data sources
  sl.registerLazySingleton<FeelingLocalDataSource>(
    () => FeelingLocalDataSourceImpl(),
  );

  // Feeling repositories
  sl.registerLazySingleton<FeelingRepository>(
    () => FeelingRepositoryImpl(localDataSource: sl<FeelingLocalDataSource>()),
  );

  // Feeling use cases
  sl.registerLazySingleton<SaveFeelingUseCase>(
    () => SaveFeelingUseCase(sl<FeelingRepository>()),
  );
  sl.registerLazySingleton<GetCurrentFeelingUseCase>(
    () => GetCurrentFeelingUseCase(sl<FeelingRepository>()),
  );
  sl.registerLazySingleton<GetFeelingHistoryUseCase>(
    () => GetFeelingHistoryUseCase(sl<FeelingRepository>()),
  );

  // Feeling cubit
  sl.registerFactory<FeelingCubit>(
    () => FeelingCubit(
      sl<SaveFeelingUseCase>(),
      sl<GetCurrentFeelingUseCase>(),
      sl<GetFeelingHistoryUseCase>(),
    ),
  );

  // Music data sources
  sl.registerLazySingleton<MusicLocalDataSource>(
    () => MusicLocalDataSourceImpl(),
  );

  // Music repositories
  sl.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(dataSource: sl<MusicLocalDataSource>()),
  );

  // Music use cases
  sl.registerLazySingleton<GetRecommendedMusicUseCase>(
    () => GetRecommendedMusicUseCase(sl<MusicRepository>()),
  );
  sl.registerLazySingleton<GetTracksByGoalUseCase>(
    () => GetTracksByGoalUseCase(sl<MusicRepository>()),
  );
  sl.registerLazySingleton<GetTrackByIdUseCase>(
    () => GetTrackByIdUseCase(sl<MusicRepository>()),
  );
  sl.registerLazySingleton<GetBreathingExercisesUseCase>(
    () => GetBreathingExercisesUseCase(sl<MusicRepository>()),
  );
  sl.registerLazySingleton<SaveLastSelectedFeelingUseCase>(
    () => SaveLastSelectedFeelingUseCase(sl<MusicRepository>()),
  );
  sl.registerLazySingleton<GetLastSelectedFeelingUseCase>(
    () => GetLastSelectedFeelingUseCase(sl<MusicRepository>()),
  );

  // Music cubit
  sl.registerFactory<MusicCubit>(
    () => MusicCubit(
      sl<GetRecommendedMusicUseCase>(),
      sl<GetBreathingExercisesUseCase>(),
      sl<GetLastSelectedFeelingUseCase>(),
      sl<SaveLastSelectedFeelingUseCase>(),
    ),
  );

  // Assignments data sources
  sl.registerLazySingleton<AssignmentsRemoteDataSource>(
    () => useMockDataSources
        ? AssignmentsMockDataSourceImpl()
        : AssignmentsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Assignments repositories
  sl.registerLazySingleton<AssignmentsRepository>(
    () => AssignmentsRepositoryImpl(
      remoteDataSource: sl<AssignmentsRemoteDataSource>(),
    ),
  );

  // Assignments use cases
  sl.registerLazySingleton<GetAssignmentQuestionsUseCase>(
    () => GetAssignmentQuestionsUseCase(sl<AssignmentsRepository>()),
  );
  sl.registerLazySingleton<SubmitAssignmentUseCase>(
    () => SubmitAssignmentUseCase(sl<AssignmentsRepository>()),
  );

  // Assignments cubit
  sl.registerFactory<AssignmentsCubit>(
    () => AssignmentsCubit(
      sl<GetAssignmentQuestionsUseCase>(),
      sl<SubmitAssignmentUseCase>(),
      sl<GetAllDoctorsUseCase>(),
      sl<GetDoctorsBySpecialtyUseCase>(),
    ),
  );

  // Doctors cubits
  sl.registerFactory<DoctorsCubit>(
    () => DoctorsCubit(
      sl<GetAllDoctorsUseCase>(),
      sl<GetDoctorsBySpecialtyUseCase>(),
      sl<GetDoctorByIdUseCase>(),
    ),
  );
  // Settings data sources
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => useMockDataSources
        ? SettingsMockDataSourceImpl()
        : SettingsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Settings repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: sl<SettingsRemoteDataSource>(),
    ),
  );

  // Settings use cases
  sl.registerLazySingleton<GetMedicalProfileUseCase>(
    () => GetMedicalProfileUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<SubmitReportIssueUseCase>(
    () => SubmitReportIssueUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<UpdateMedicalNoteUseCase>(
    () => UpdateMedicalNoteUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<ShareMedicalNoteWithDoctorUseCase>(
    () => ShareMedicalNoteWithDoctorUseCase(sl<SettingsRepository>()),
  );

  // Settings cubit
  sl.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      sl<GetMedicalProfileUseCase>(),
      sl<SubmitReportIssueUseCase>(),
      sl<UpdateMedicalNoteUseCase>(),
      sl<ShareMedicalNoteWithDoctorUseCase>(),
    ),
  );

  // Report data sources
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Report repositories
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: sl<ReportRemoteDataSource>()),
  );

  // Report use cases
  sl.registerLazySingleton<SubmitReportUseCase>(
    () => SubmitReportUseCase(sl<ReportRepository>()),
  );
  sl.registerLazySingleton<GetReportHistoryUseCase>(
    () => GetReportHistoryUseCase(sl<ReportRepository>()),
  );
  sl.registerLazySingleton<GetReportsByTypeUseCase>(
    () => GetReportsByTypeUseCase(sl<ReportRepository>()),
  );

  // Report cubit
  sl.registerFactory<ReportCubit>(
    () => ReportCubit(
      submitReportUseCase: sl<SubmitReportUseCase>(),
      getReportHistoryUseCase: sl<GetReportHistoryUseCase>(),
      getReportsByTypeUseCase: sl<GetReportsByTypeUseCase>(),
    ),
  );

  // Articles data sources
  sl.registerLazySingleton<ArticlesRemoteDataSource>(
    () => ArticlesMockDataSourceImpl(),
  );

  // Articles repositories
  sl.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(
      remoteDataSource: sl<ArticlesRemoteDataSource>(),
    ),
  );

  // Articles use cases
  sl.registerLazySingleton<GetArticlesForHomeUseCase>(
    () => GetArticlesForHomeUseCase(sl<ArticlesRepository>()),
  );
  sl.registerLazySingleton<GetArticlesByDoctorUseCase>(
    () => GetArticlesByDoctorUseCase(sl<ArticlesRepository>()),
  );
  sl.registerLazySingleton<GetAllArticlesUseCase>(
    () => GetAllArticlesUseCase(sl<ArticlesRepository>()),
  );
  sl.registerLazySingleton<GetArticleByIdUseCase>(
    () => GetArticleByIdUseCase(sl<ArticlesRepository>()),
  );
  sl.registerLazySingleton<LikeArticleUseCase>(
    () => LikeArticleUseCase(sl<ArticlesRepository>()),
  );
  sl.registerLazySingleton<DislikeArticleUseCase>(
    () => DislikeArticleUseCase(sl<ArticlesRepository>()),
  );

  // Articles cubit
  sl.registerFactory<ArticlesCubit>(
    () => ArticlesCubit(
      getArticlesForHomeUseCase: sl<GetArticlesForHomeUseCase>(),
      getArticlesByDoctorUseCase: sl<GetArticlesByDoctorUseCase>(),
      getAllArticlesUseCase: sl<GetAllArticlesUseCase>(),
      getArticleByIdUseCase: sl<GetArticleByIdUseCase>(),
      likeArticleUseCase: sl<LikeArticleUseCase>(),
      dislikeArticleUseCase: sl<DislikeArticleUseCase>(),
    ),
  );
}
