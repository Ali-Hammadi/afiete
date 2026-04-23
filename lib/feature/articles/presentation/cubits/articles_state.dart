part of 'articles_cubit.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object?> get props => [];
}

class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class ArticlesLoaded extends ArticlesState {
  final List<ArticleEntity> articles;
  final bool isForHome;

  const ArticlesLoaded({required this.articles, this.isForHome = false});

  @override
  List<Object?> get props => [articles, isForHome];
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleDetailsLoaded extends ArticlesState {
  final ArticleEntity article;

  const ArticleDetailsLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

class ArticleLikeToggled extends ArticlesState {
  final ArticleEntity article;
  final bool liked;

  const ArticleLikeToggled({required this.article, required this.liked});

  @override
  List<Object?> get props => [article, liked];
}
