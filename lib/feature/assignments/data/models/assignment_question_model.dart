import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';

abstract class AssignmentModel {
  static AssignmentEntity fromQuestionJson(Map<String, dynamic> json) {
    final rawOptions =
        (json['options'] ?? json['choices'] ?? const <dynamic>[])
            as List<dynamic>;

    final normalizedOptions = rawOptions
        .map((option) => _normalizeOption(option.toString()))
        .where((option) => option.isNotEmpty)
        .toList();

    final options = normalizedOptions.length == 5
        ? normalizedOptions
        : AssignmentEntity.standardOptions;

    return AssignmentEntity.question(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      questionText:
          (json['questionText'] ?? json['question'] ?? json['text'] ?? '')
              .toString(),
      options: options,
      validation: (json['validation'] ?? '').toString(),
    );
  }

  static AssignmentEntity fromResultJson(Map<String, dynamic> json) {
    final recommendation =
        (json['recommendation'] ?? json['recommendations'] ?? const {})
            as Map<String, dynamic>;

    final doctorIdsRaw =
        (recommendation['doctorIds'] ??
                json['recommendedDoctorIds'] ??
                const [])
            as List<dynamic>;
    final specialtiesRaw =
        (recommendation['specialties'] ??
                json['recommendedSpecialties'] ??
                const [])
            as List<dynamic>;

    return AssignmentEntity.result(
      resultId: (json['resultId'] ?? json['id'] ?? '').toString(),
      score: (json['score'] as num?)?.toInt() ?? 0,
      severity: (json['severity'] ?? json['level'] ?? 'unknown').toString(),
      summary: (json['summary'] ?? json['message'] ?? '').toString(),
      recommendedDoctorIds: doctorIdsRaw
          .map((doctorId) => doctorId.toString())
          .toList(),
      recommendedSpecialties: specialtiesRaw
          .map((specialty) => specialty.toString())
          .toList(),
    );
  }

  static String _normalizeOption(String option) {
    final value = option.trim().toLowerCase();
    switch (value) {
      case 'never':
        return 'Never';
      case 'sometimes':
        return 'Sometimes';
      case 'often':
        return 'Often';
      case 'always':
        return 'Always';
      case 'extremely':
        return 'Extremely';
      default:
        return '';
    }
  }
}
