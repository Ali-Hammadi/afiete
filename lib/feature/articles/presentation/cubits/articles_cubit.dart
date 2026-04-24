import 'dart:math';

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
  final DislikeArticleUseCase dislikeArticleUseCase;
  List<ArticleEntity>? _currentArticles;
  bool _currentIsForHome = false;
  String? _currentDoctorId;
  String? _currentUserDiagnosis;
  bool _loadedAllArticles = false;

  ArticlesCubit({
    required this.getArticlesForHomeUseCase,
    required this.getArticlesByDoctorUseCase,
    required this.getAllArticlesUseCase,
    required this.getArticleByIdUseCase,
    required this.likeArticleUseCase,
    required this.dislikeArticleUseCase,
  }) : super(const ArticlesInitial());

  Future<void> loadArticlesForHome({String? userDiagnosis}) async {
    emit(const ArticlesLoading());
    _currentDoctorId = null;
    _loadedAllArticles = false;
    _currentUserDiagnosis = userDiagnosis;
    final result = await getArticlesForHomeUseCase(
      userDiagnosis: userDiagnosis,
      limit: 5,
    );

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = _sortArticles(articles);
      _currentIsForHome = true;
      emit(ArticlesLoaded(articles: _currentArticles!, isForHome: true));
    });
  }

  Future<void> loadArticlesByDoctor(String doctorId) async {
    emit(const ArticlesLoading());
    _currentDoctorId = doctorId;
    _loadedAllArticles = false;
    _currentUserDiagnosis = null;
    final result = await getArticlesByDoctorUseCase(doctorId);

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = _sortArticles(articles);
      _currentIsForHome = false;
      emit(ArticlesLoaded(articles: _currentArticles!, isForHome: false));
    });
  }

  Future<void> loadAllArticles({int page = 1, int pageSize = 10}) async {
    emit(const ArticlesLoading());
    _currentDoctorId = null;
    _currentUserDiagnosis = null;
    _loadedAllArticles = true;
    final result = await getAllArticlesUseCase(page: page, pageSize: pageSize);

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = _sortArticles(articles);
      _currentIsForHome = false;
      emit(ArticlesLoaded(articles: _currentArticles!, isForHome: false));
    });
  }

  Future<void> loadArticleById(String articleId) async {
    emit(const ArticlesLoading());
    final result = await getArticleByIdUseCase(articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.errorMessage)),
      (article) => emit(ArticleDetailsLoaded(article)),
    );
  }

  Future<void> reloadCurrent() async {
    if (_currentDoctorId != null) {
      await loadArticlesByDoctor(_currentDoctorId!);
      return;
    }

    if (_loadedAllArticles) {
      await loadAllArticles();
      return;
    }

    await loadArticlesForHome(userDiagnosis: _currentUserDiagnosis);
  }

  Future<void> toggleLike(ArticleEntity article) async {
    await likeArticleUseCase(article.id);

    final currentArticle = _findCurrentArticle(article.id) ?? article;
    final updatedArticle = currentArticle.isLikedByUser
        ? currentArticle.copyWith(
            isLikedByUser: false,
            likesCount: max(0, currentArticle.likesCount - 1),
          )
        : currentArticle.copyWith(
            isLikedByUser: true,
            isDislikedByUser: false,
            likesCount: currentArticle.likesCount + 1,
            dislikesCount: currentArticle.isDislikedByUser
                ? max(0, currentArticle.dislikesCount - 1)
                : currentArticle.dislikesCount,
          );

    _emitUpdatedArticle(updatedArticle);
  }

  Future<void> toggleDislike(ArticleEntity article) async {
    await dislikeArticleUseCase(article.id);

    final currentArticle = _findCurrentArticle(article.id) ?? article;
    final updatedArticle = currentArticle.isDislikedByUser
        ? currentArticle.copyWith(
            isDislikedByUser: false,
            dislikesCount: max(0, currentArticle.dislikesCount - 1),
          )
        : currentArticle.copyWith(
            isDislikedByUser: true,
            isLikedByUser: false,
            dislikesCount: currentArticle.dislikesCount + 1,
            likesCount: currentArticle.isLikedByUser
                ? max(0, currentArticle.likesCount - 1)
                : currentArticle.likesCount,
          );

    _emitUpdatedArticle(updatedArticle);
  }

  ArticleEntity? _findCurrentArticle(String articleId) {
    final currentArticles = _currentArticles;
    if (currentArticles == null) {
      return null;
    }

    for (final article in currentArticles) {
      if (article.id == articleId) {
        return article;
      }
    }

    return null;
  }

  List<ArticleEntity> _sortArticles(List<ArticleEntity> articles) {
    final sorted = List<ArticleEntity>.from(articles);
    sorted.sort((a, b) {
      final likesComparison = b.likesCount.compareTo(a.likesCount);
      if (likesComparison != 0) {
        return likesComparison;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return sorted;
  }

  void _emitUpdatedArticle(ArticleEntity updatedArticle) {
    final currentArticles = _currentArticles;
    if (currentArticles != null && currentArticles.isNotEmpty) {
      final updatedArticles = _sortArticles(
        currentArticles
            .map(
              (article) =>
                  article.id == updatedArticle.id ? updatedArticle : article,
            )
            .toList(growable: false),
      );
      _currentArticles = updatedArticles;
      emit(
        ArticlesLoaded(articles: updatedArticles, isForHome: _currentIsForHome),
      );
      return;
    }

    emit(ArticleDetailsLoaded(updatedArticle));
  }
}
