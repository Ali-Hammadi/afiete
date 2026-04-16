import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserAuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.login(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> deleteAccount(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.deleteAccount(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> logout(
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.logout(email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final remoteUser = await remoteDataSource.signup(name, email, password);
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> googleSignIn() async {
    try {
      final remoteUser = await remoteDataSource.googleSignIn();
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> updateProfileInfo({
    required String userId,
    required String name,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
  }) async {
    try {
      final remoteUser = await remoteDataSource.updateProfileInfo(
        userId: userId,
        name: name,
        birthDate: birthDate,
        gender: gender,
        phoneNumber: phoneNumber,
      );
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> requestEmailChangeOtp({
    required String userId,
    required String newEmail,
  }) async {
    try {
      final result = await remoteDataSource.requestEmailChangeOtp(
        userId: userId,
        newEmail: newEmail,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthEntity>> confirmEmailChange({
    required String userId,
    required String newEmail,
    required String otp,
  }) async {
    try {
      final remoteUser = await remoteDataSource.confirmEmailChange(
        userId: userId,
        newEmail: newEmail,
        otp: otp,
      );
      return Right(remoteUser.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
