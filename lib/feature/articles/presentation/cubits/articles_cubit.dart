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
    final result = await getArticlesForHomeUseCase(
      userDiagnosis: userDiagnosis,
      limit: 5,
    );

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = articles;
      _currentIsForHome = true;
      emit(ArticlesLoaded(articles: articles, isForHome: true));
    });
  }

  Future<void> loadArticlesByDoctor(String doctorId) async {
    emit(const ArticlesLoading());
    final result = await getArticlesByDoctorUseCase(doctorId);

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = articles;
      _currentIsForHome = false;
      emit(ArticlesLoaded(articles: articles, isForHome: false));
    });
  }

  Future<void> loadAllArticles({int page = 1, int pageSize = 10}) async {
    emit(const ArticlesLoading());
    final result = await getAllArticlesUseCase(page: page, pageSize: pageSize);

    result.fold((failure) => emit(ArticlesError(failure.errorMessage)), (
      articles,
    ) {
      _currentArticles = articles;
      _currentIsForHome = false;
      emit(ArticlesLoaded(articles: articles, isForHome: false));
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

  Future<void> toggleLike(ArticleEntity article) async {
    final newArticle = article.copyWith(
      isLikedByUser: !article.isLikedByUser,
      likesCount: article.isLikedByUser
          ? article.likesCount - 1
          : article.likesCount + 1,
    );

    if (!article.isLikedByUser) {
      await likeArticleUseCase(article.id);
    }

    _emitUpdatedArticle(newArticle);
  }

  Future<void> toggleDislike(ArticleEntity article) async {
    final newArticle = article.copyWith(
      isDislikedByUser: !article.isDislikedByUser,
      dislikesCount: article.isDislikedByUser
          ? article.dislikesCount - 1
          : article.dislikesCount + 1,
    );

    if (!article.isDislikedByUser) {
      await dislikeArticleUseCase(article.id);
    }

    _emitUpdatedArticle(newArticle);
  }

  void _emitUpdatedArticle(ArticleEntity updatedArticle) {
    final currentArticles = _currentArticles;
    if (currentArticles != null && currentArticles.isNotEmpty) {
      final updatedArticles = currentArticles
          .map(
            (article) =>
                article.id == updatedArticle.id ? updatedArticle : article,
          )
          .toList(growable: false);
      _currentArticles = updatedArticles;
      emit(
        ArticlesLoaded(articles: updatedArticles, isForHome: _currentIsForHome),
      );
      return;
    }

    emit(ArticleDetailsLoaded(updatedArticle));
  }
}
