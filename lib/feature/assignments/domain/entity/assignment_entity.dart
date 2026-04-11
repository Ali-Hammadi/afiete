import 'package:equatable/equatable.dart';

enum AssignmentEntityType { question, answer, result }

class AssignmentEntity extends Equatable {
  static const List<String> standardOptions = [
    'Never',
    'Sometimes',
    'Often',
    'Always',
    'Extremely',
  ];

  final AssignmentEntityType type;
  final String id;
  final String questionText;
  final List<String> options;
  final String validation;
  final String questionId;
  final String selectedOption;
  final String resultId;
  final int score;
  final String severity;
  final String summary;
  final List<String> recommendedDoctorIds;
  final List<String> recommendedSpecialties;

  const AssignmentEntity._({
    required this.type,
    this.id = '',
    this.questionText = '',
    this.options = const [],
    this.validation = '',
    this.questionId = '',
    this.selectedOption = '',
    this.resultId = '',
    this.score = 0,
    this.severity = '',
    this.summary = '',
    this.recommendedDoctorIds = const [],
    this.recommendedSpecialties = const [],
  });

  const AssignmentEntity.question({
    required String id,
    required String questionText,
    required List<String> options,
    String validation = '',
  }) : this._(
         type: AssignmentEntityType.question,
         id: id,
         questionText: questionText,
         options: options,
         validation: validation,
       );

  const AssignmentEntity.answer({
    required String questionId,
    required String selectedOption,
  }) : this._(
         type: AssignmentEntityType.answer,
         questionId: questionId,
         selectedOption: selectedOption,
       );

  const AssignmentEntity.result({
    required String resultId,
    required int score,
    required String severity,
    required String summary,
    required List<String> recommendedDoctorIds,
    required List<String> recommendedSpecialties,
  }) : this._(
         type: AssignmentEntityType.result,
         resultId: resultId,
         score: score,
         severity: severity,
         summary: summary,
         recommendedDoctorIds: recommendedDoctorIds,
         recommendedSpecialties: recommendedSpecialties,
       );

  @override
  List<Object?> get props => [
    type,
    id,
    questionText,
    options,
    validation,
    questionId,
    selectedOption,
    resultId,
    score,
    severity,
    summary,
    recommendedDoctorIds,
    recommendedSpecialties,
  ];
}
