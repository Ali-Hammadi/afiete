import 'package:afiete/feature/assignments/data/datasources/assignments_remote_datasource.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';

class AssignmentsMockDataSourceImpl implements AssignmentsRemoteDataSource {
  @override
  Future<List<AssignmentEntity>> getAssignmentQuestions() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const [
      AssignmentEntity.question(
        id: 'q1',
        questionText: 'I feel nervous or anxious without a clear reason.',
        options: AssignmentEntity.standardOptions,
      ),
      AssignmentEntity.question(
        id: 'q2',
        questionText: 'I have difficulty sleeping because of stress.',
        options: AssignmentEntity.standardOptions,
      ),
      AssignmentEntity.question(
        id: 'q3',
        questionText: 'I avoid social interactions more than usual.',
        options: AssignmentEntity.standardOptions,
      ),
      AssignmentEntity.question(
        id: 'q4',
        questionText: 'I struggle to concentrate during daily tasks.',
        options: AssignmentEntity.standardOptions,
      ),
      AssignmentEntity.question(
        id: 'q5',
        questionText: 'I feel emotionally drained most days.',
        options: AssignmentEntity.standardOptions,
      ),
    ];
  }

  @override
  Future<AssignmentEntity> submitAssignment({
    required List<AssignmentEntity> answers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));

    int score = 0;
    for (final answer in answers) {
      switch (answer.selectedOption) {
        case 'Never':
          score += 0;
          break;
        case 'Sometimes':
          score += 1;
          break;
        case 'Often':
          score += 2;
          break;
        case 'Always':
          score += 3;
          break;
        case 'Extremely':
          score += 4;
          break;
        default:
          score += 0;
      }
    }

    final String severity;
    final String summary;
    final List<String> specialties;

    if (score <= 4) {
      severity = 'low';
      summary = 'Your responses indicate mild stress levels.';
      specialties = const ['Counselor'];
    } else if (score <= 10) {
      severity = 'moderate';
      summary = 'Your responses suggest moderate emotional strain.';
      specialties = const ['Psychotherapist', 'CBT Therapist'];
    } else {
      severity = 'high';
      summary =
          'Your responses indicate high stress/anxiety. Consider professional support soon.';
      specialties = const ['Psychiatrist', 'Clinical Psychologist'];
    }

    return AssignmentEntity.result(
      resultId: 'result-${DateTime.now().millisecondsSinceEpoch}',
      score: score,
      severity: severity,
      summary: summary,
      recommendedDoctorIds: const ['doc_1', 'doc_2'],
      recommendedSpecialties: specialties,
    );
  }
}
