import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/google_signin_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:afiete/feature/booking_assiments/data/datasources/appointments_mock_datasource.dart';
import 'package:afiete/feature/booking_assiments/data/repositories/appointments_repository_impl.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/create_appointment_usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/usecase/get_appointments_usecase.dart';
import 'package:afiete/feature/booking_assiments/presentation/cubits/appointments_cubit.dart';
import 'package:afiete/feature/doctors/data/datasources/doctors_remote_datasource.dart';
import 'package:afiete/feature/doctors/data/repositories/doctors_repository_impl.dart';
import 'package:afiete/feature/doctors/domain/repositories/doctors_repository.dart';
import 'package:afiete/feature/doctors/domain/usecase/get_doctors_usecase.dart';
import 'package:afiete/feature/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:afiete/feature/sessions/data/datasources/sessions_mock_datasource.dart';
import 'package:afiete/feature/sessions/data/repositories/sessions_repository_impl.dart';
import 'package:afiete/feature/sessions/domain/repositories/sessions_repository.dart';
import 'package:afiete/feature/sessions/domain/usecase/add_review_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/cancel_session_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_past_sessions_usecase.dart';
import 'package:afiete/feature/sessions/domain/usecase/get_upcoming_sessions_usecase.dart';
import 'package:afiete/feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:afiete/feature/auth/domain/usecase/login_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/signup_usecase.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
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

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      sl<LoginUseCase>(),
      sl<SignupUseCase>(),
      sl<LogoutUseCase>(),
      sl<DeleteAccountUseCase>(),
      sl<GoogleSignInUseCase>(),
    ),
  );

  // Booking assignments data sources
  sl.registerLazySingleton<AppointmentsMockDataSource>(
    () => AppointmentsMockDataSourceImpl(),
  );

  // Booking assignments repositories
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(
      dataSource: sl<AppointmentsMockDataSource>(),
    ),
  );

  // Booking assignments use cases
  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton<CreateAppointmentUseCase>(
    () => CreateAppointmentUseCase(sl<AppointmentsRepository>()),
  );

  // Booking assignments cubits
  sl.registerFactory<AppointmentsCubit>(
    () => AppointmentsCubit(
      sl<GetAppointmentsUseCase>(),
      sl<CreateAppointmentUseCase>(),
    ),
  );

  // Sessions data sources
  sl.registerLazySingleton<SessionsMockDataSource>(
    () => SessionsMockDataSourceImpl(),
  );

  // Sessions repositories
  sl.registerLazySingleton<SessionsRepository>(
    () => SessionsRepositoryImpl(dataSource: sl<SessionsMockDataSource>()),
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
  sl.registerLazySingleton<AddReviewUseCase>(
    () => AddReviewUseCase(sl<SessionsRepository>()),
  );

  // Sessions cubits
  sl.registerFactory<SessionsCubit>(
    () => SessionsCubit(
      sl<GetUpcomingSessionsUseCase>(),
      sl<GetPastSessionsUseCase>(),
      sl<CancelSessionUseCase>(),
      sl<AddReviewUseCase>(),
    ),
  );

  // Doctors data sources
  sl.registerLazySingleton<DoctorsRemoteDataSource>(
    () => DoctorsRemoteDataSourceImpl(),
  );

  // Doctors repositories
  sl.registerLazySingleton<DoctorsRepository>(
    () => DoctorsRepositoryImpl(remoteDataSource: sl<DoctorsRemoteDataSource>()),
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

  // Doctors cubits
  sl.registerFactory<DoctorsCubit>(
    () => DoctorsCubit(
      sl<GetAllDoctorsUseCase>(),
      sl<GetDoctorsBySpecialtyUseCase>(),
      sl<GetDoctorByIdUseCase>(),
    ),
  );
}
