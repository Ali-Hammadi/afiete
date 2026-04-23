import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/feature/articles/data/models/article_model.dart';
import 'package:dio/dio.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  });

  Future<List<ArticleModel>> getArticlesByDoctor(String doctorId);
  Future<List<ArticleModel>> getAllArticles({int page = 1, int pageSize = 10});
  Future<ArticleModel> getArticleById(String articleId);
  Future<void> likeArticle(String articleId);
  Future<void> unlikeArticle(String articleId);
  Future<void> dislikeArticle(String articleId);
  Future<void> undislikeArticle(String articleId);
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  final Dio _dio;

  ArticlesRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<ArticleModel>> getArticlesForHome({
    String? userDiagnosis,
    int limit = 5,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.allArticles,
      queryParameters: {
        ApiEndpoints.keyUserDiagnosis: userDiagnosis,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final body = response.data;
      final raw = body is Map<String, dynamic>
          ? (body['articles'] ?? body['data'] ?? body['items'])
          : body;

      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ArticleModel.fromJson)
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<List<ArticleModel>> getArticlesByDoctor(String doctorId) async {
    final response = await _dio.get(ApiEndpoints.articlesByDoctor(doctorId));

    if (response.statusCode == 200) {
      final body = response.data;
      final raw = body is Map<String, dynamic>
          ? (body['articles'] ?? body['data'] ?? body['items'])
          : body;

      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ArticleModel.fromJson)
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<List<ArticleModel>> getAllArticles({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.allArticles,
      queryParameters: {
        ApiEndpoints.keyPage: page,
        ApiEndpoints.keyPageSize: pageSize,
      },
    );

    if (response.statusCode == 200) {
      final body = response.data;
      final raw = body is Map<String, dynamic>
          ? (body['articles'] ?? body['data'] ?? body['items'])
          : body;

      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ArticleModel.fromJson)
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<ArticleModel> getArticleById(String articleId) async {
    final response = await _dio.get(ApiEndpoints.articleById(articleId));

    if (response.statusCode == 200) {
      final body = response.data;
      final raw = body is Map<String, dynamic>
          ? (body['article'] ?? body['data'] ?? body)
          : body;

      if (raw is Map<String, dynamic>) {
        return ArticleModel.fromJson(raw);
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<void> likeArticle(String articleId) async {
    await _dio.post(ApiEndpoints.articleLike(articleId));
  }

  @override
  Future<void> unlikeArticle(String articleId) async {
    // Some backends expose explicit unlike endpoints, while others toggle on same route.
    await _dio.post(ApiEndpoints.articleLike(articleId));
  }

  @override
  Future<void> dislikeArticle(String articleId) async {
    await _dio.post(ApiEndpoints.articleDislike(articleId));
  }

  @override
  Future<void> undislikeArticle(String articleId) async {
    // Some backends expose explicit undislike endpoints, while others toggle on same route.
    await _dio.post(ApiEndpoints.articleDislike(articleId));
  }
}
