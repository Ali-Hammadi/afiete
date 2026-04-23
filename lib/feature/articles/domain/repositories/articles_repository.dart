import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<ArticleEntity>>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  });
  Future<Either<Failure, List<ArticleEntity>>> getArticlesByDoctor(
    String doctorId,
  );
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles({
    int page = 1,
    int pageSize = 10,
  });
  Future<Either<Failure, ArticleEntity>> getArticleById(String articleId);
  Future<Either<Failure, void>> likeArticle(String articleId);
  Future<Either<Failure, void>> dislikeArticle(String articleId);
}
