import 'package:afiete/feature/auth/domain/usecase/delete_account_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/google_signin_usecase.dart';
import 'package:afiete/feature/auth/domain/usecase/logout_usecase.dart';
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
}
