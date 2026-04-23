import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:afiete/feature/articles/domain/repositories/articles_repository.dart';

class GetArticlesForHomeUseCase {
  final ArticlesRepository repository;

  GetArticlesForHomeUseCase(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call({
    String? userDiagnosis,
    int limit = 5,
  }) {
    return repository.getArticlesForHome(
      userDiagnosis: userDiagnosis,
      limit: limit,
    );
  }
}

class GetArticlesByDoctorUseCase {
  final ArticlesRepository repository;

  GetArticlesByDoctorUseCase(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call(String doctorId) {
    return repository.getArticlesByDoctor(doctorId);
  }
}

class GetAllArticlesUseCase {
  final ArticlesRepository repository;

  GetAllArticlesUseCase(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call({
    int page = 1,
    int pageSize = 10,
  }) {
    return repository.getAllArticles(page: page, pageSize: pageSize);
  }
}

class GetArticleByIdUseCase {
  final ArticlesRepository repository;

  GetArticleByIdUseCase(this.repository);

  Future<Either<Failure, ArticleEntity>> call(String articleId) {
    return repository.getArticleById(articleId);
  }
}

class LikeArticleUseCase {
  final ArticlesRepository repository;

  LikeArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(String articleId) {
    return repository.likeArticle(articleId);
  }
}

class DislikeArticleUseCase {
  final ArticlesRepository repository;

  DislikeArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(String articleId) {
    return repository.dislikeArticle(articleId);
  }
}
