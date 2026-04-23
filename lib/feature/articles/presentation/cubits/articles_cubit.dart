import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:afiete/feature/articles/domain/usecases/articles_usecases.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetArticlesForHomeUseCase getArticlesForHomeUseCase;
  final GetArticlesByDoctorUseCase getArticlesByDoctorUseCase;
  final GetAllArticlesUseCase getAllArticlesUseCase;
  final GetArticleByIdUseCase getArticleByIdUseCase;
  final LikeArticleUseCase likeArticleUseCase;
  final UnlikeArticleUseCase unlikeArticleUseCase;
  final DislikeArticleUseCase dislikeArticleUseCase;
  final UndislikeArticleUseCase undislikeArticleUseCase;

  ArticlesCubit({
    required this.getArticlesForHomeUseCase,
    required this.getArticlesByDoctorUseCase,
    required this.getAllArticlesUseCase,
    required this.getArticleByIdUseCase,
    required this.likeArticleUseCase,
    required this.unlikeArticleUseCase,
    required this.dislikeArticleUseCase,
    required this.undislikeArticleUseCase,
  }) : super(const ArticlesInitial());

  ArticleEntity _resolveCurrentArticle(ArticleEntity article) {
    final currentState = state;
    if (currentState is! ArticlesLoaded) {
      return article;
    }

    return currentState.articles.firstWhere(
      (item) => item.id == article.id,
      orElse: () => article,
    );
  }

  void _emitUpdatedArticle(ArticleEntity updatedArticle) {
    final currentState = state;
    if (currentState is! ArticlesLoaded) {
      return;
    }

    final updatedArticles = currentState.articles
        .map((item) => item.id == updatedArticle.id ? updatedArticle : item)
        .toList();

    emit(
      ArticlesLoaded(
        articles: updatedArticles,
        isForHome: currentState.isForHome,
      ),
    );
  }

  Future<void> loadArticlesForHome({String? userDiagnosis}) async {
    emit(const ArticlesLoading());
    final result = await getArticlesForHomeUseCase(
      userDiagnosis: userDiagnosis,
      limit: 5,
    );

    result.fold(
      (failure) => emit(ArticlesError(failure.errorMessage)),
      (articles) => emit(ArticlesLoaded(articles: articles, isForHome: true)),
    );
  }

  Future<void> loadArticlesByDoctor(String doctorId) async {
    emit(const ArticlesLoading());
    final result = await getArticlesByDoctorUseCase(doctorId);

    result.fold(
      (failure) => emit(ArticlesError(failure.errorMessage)),
      (articles) => emit(ArticlesLoaded(articles: articles, isForHome: false)),
    );
  }

  Future<void> loadAllArticles({int page = 1, int pageSize = 10}) async {
    emit(const ArticlesLoading());
    final result = await getAllArticlesUseCase(page: page, pageSize: pageSize);

    result.fold(
      (failure) => emit(ArticlesError(failure.errorMessage)),
      (articles) => emit(ArticlesLoaded(articles: articles, isForHome: false)),
    );
  }

  Future<void> loadArticleById(String articleId) async {
    emit(const ArticlesLoading());
    final result = await getArticleByIdUseCase(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.errorMessage)),
      (article) => emit(ArticleDetailsLoaded(article)),
    );
  }

  Future<void> toggleLike(ArticleEntity article) async {
    final currentArticle = _resolveCurrentArticle(article);

    final wasLiked = currentArticle.isLikedByUser;
    final wasDisliked = currentArticle.isDislikedByUser;

    final newArticle = currentArticle.copyWith(
      // Like acts as toggle: tap again removes it.
      isLikedByUser: !wasLiked,
      // If like is turned on, dislike must be turned off.
      isDislikedByUser: wasLiked ? wasDisliked : false,
      likesCount: wasLiked
          ? (currentArticle.likesCount > 0 ? currentArticle.likesCount - 1 : 0)
          : currentArticle.likesCount + 1,
      dislikesCount: (!wasLiked && wasDisliked)
          ? (currentArticle.dislikesCount > 0
                ? currentArticle.dislikesCount - 1
                : 0)
          : currentArticle.dislikesCount,
    );

    _emitUpdatedArticle(newArticle);

    if (wasLiked) {
      await unlikeArticleUseCase(article.id);
      return;
    }

    await likeArticleUseCase(article.id);
  }

  Future<void> toggleDislike(ArticleEntity article) async {
    final currentArticle = _resolveCurrentArticle(article);

    final wasLiked = currentArticle.isLikedByUser;
    final wasDisliked = currentArticle.isDislikedByUser;

    final newArticle = currentArticle.copyWith(
      // Dislike acts as toggle: tap again removes it.
      isDislikedByUser: !wasDisliked,
      // If dislike is turned on, like must be turned off.
      isLikedByUser: wasDisliked ? wasLiked : false,
      dislikesCount: wasDisliked
          ? (currentArticle.dislikesCount > 0
                ? currentArticle.dislikesCount - 1
                : 0)
          : currentArticle.dislikesCount + 1,
      likesCount: (!wasDisliked && wasLiked)
          ? (currentArticle.likesCount > 0 ? currentArticle.likesCount - 1 : 0)
          : currentArticle.likesCount,
    );

    _emitUpdatedArticle(newArticle);

    if (wasDisliked) {
      await undislikeArticleUseCase(article.id);
      return;
    }

    await dislikeArticleUseCase(article.id);
  }
}
