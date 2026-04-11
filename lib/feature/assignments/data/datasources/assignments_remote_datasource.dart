import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/feature/assignments/data/models/assignment_question_model.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:dio/dio.dart';

abstract class AssignmentsRemoteDataSource {
  Future<List<AssignmentEntity>> getAssignmentQuestions();

  Future<AssignmentEntity> submitAssignment({
    required List<AssignmentEntity> answers,
  });
}

class AssignmentsRemoteDataSourceImpl implements AssignmentsRemoteDataSource {
  final Dio _dio;

  AssignmentsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<AssignmentEntity>> getAssignmentQuestions() async {
    try {
      final response = await _dio.get(ApiEndpoints.assignmentQuestions);
      if (response.statusCode == 200) {
        final List<dynamic> data =
            (response.data['questions'] ?? response.data['data'] ?? const [])
                as List<dynamic>;
        return data
            .map(
              (question) => AssignmentModel.fromQuestionJson(
                question as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.assignmentQuestions),
        error: error,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<AssignmentEntity> submitAssignment({
    required List<AssignmentEntity> answers,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.assignmentSubmit,
        data: {
          'answers': answers
              .map(
                (answer) => {
                  'questionId': answer.questionId,
                  'selectedOption': answer.selectedOption,
                },
              )
              .toList(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            (response.data['result'] ?? response.data) as Map<String, dynamic>;
        return AssignmentModel.fromResultJson(data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.assignmentSubmit),
        error: error,
        type: DioExceptionType.unknown,
      );
    }
  }
}
