import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/articles/data/datasources/articles_mock_datasource.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:afiete/feature/articles/domain/repositories/articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;

  const ArticlesRepositoryImpl({required this.remoteDataSource});

  List<ArticleEntity> _onlyDoctorLinked(List<ArticleEntity> articles) {
    return articles
        .where(
          (article) =>
              article.doctor.id.trim().isNotEmpty &&
              article.doctor.name.trim().isNotEmpty,
        )
        .toList(growable: false);
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  }) async {
    try {
      final articles = await remoteDataSource.getArticlesForHome(
        userDiagnosis: userDiagnosis,
        limit: limit,
      );
      return Right(
        _onlyDoctorLinked(articles.map((model) => model.toEntity()).toList()),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticlesByDoctor(
    String doctorId,
  ) async {
    try {
      final articles = await remoteDataSource.getArticlesByDoctor(doctorId);
      return Right(
        _onlyDoctorLinked(articles.map((model) => model.toEntity()).toList()),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final articles =
          await remoteDataSource.getAllArticles(page: page, pageSize: pageSize);
      return Right(
        _onlyDoctorLinked(articles.map((model) => model.toEntity()).toList()),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> getArticleById(
    String articleId,
  ) async {
    try {
      final article = await remoteDataSource.getArticleById(articleId);
      final articleEntity = article.toEntity();
      if (articleEntity.doctor.id.trim().isEmpty ||
          articleEntity.doctor.name.trim().isEmpty) {
        return Left(
          ServerFailure('Article has no valid doctor link and was ignored.'),
        );
      }
      return Right(articleEntity);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeArticle(String articleId) async {
    try {
      await remoteDataSource.likeArticle(articleId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> dislikeArticle(String articleId) async {
    try {
      await remoteDataSource.dislikeArticle(articleId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
