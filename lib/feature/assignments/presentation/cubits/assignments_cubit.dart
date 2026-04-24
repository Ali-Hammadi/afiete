import 'package:afiete/core/constants/psychology_specialties.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/assignments/data/assignment_visibility_store.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/domain/usecase/get_assignment_questions_usecase.dart';
import 'package:afiete/feature/assignments/domain/usecase/submit_assignment_usecase.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/domain/usecase/get_doctors_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assignments_state.dart';

class AssignmentsCubit extends Cubit<AssignmentsState> {
  final GetAssignmentQuestionsUseCase getAssignmentQuestionsUseCase;
  final SubmitAssignmentUseCase submitAssignmentUseCase;
  final GetAllDoctorsUseCase getAllDoctorsUseCase;
  final GetDoctorsBySpecialtyUseCase getDoctorsBySpecialtyUseCase;

  AssignmentsCubit(
    this.getAssignmentQuestionsUseCase,
    this.submitAssignmentUseCase,
    this.getAllDoctorsUseCase,
    this.getDoctorsBySpecialtyUseCase,
  ) : super(const AssignmentsInitial());

  Future<void> loadQuestions() async {
    emit(const AssignmentsLoading());
    final result = await getAssignmentQuestionsUseCase(NoParams());

    result.fold(
      (failure) => emit(AssignmentsError(failure.errorMessage)),
      (questions) => emit(
        AssignmentsLoaded(
          questions: questions,
          selectedAnswers: const {},
          currentQuestionIndex: 0,
        ),
      ),
    );
  }

  void selectAnswer({required String questionId, required String answer}) {
    final currentState = state;
    if (currentState is! AssignmentsLoaded) {
      return;
    }

    final updatedAnswers = Map<String, String>.from(
      currentState.selectedAnswers,
    )..[questionId] = answer;

    emit(
      currentState.copyWith(
        selectedAnswers: updatedAnswers,
        validationError: null,
      ),
    );
  }

  void goToNextQuestion() {
    final currentState = state;
    if (currentState is! AssignmentsLoaded) {
      return;
    }

    final currentQuestionId = currentState.currentQuestion.id;
    final currentAnswer = currentState.selectedAnswers[currentQuestionId];
    if (currentAnswer == null || currentAnswer.trim().isEmpty) {
      emit(
        currentState.copyWith(
          validationError: SettingsStrings.chooseAnswerBeforeContinuing,
        ),
      );
      return;
    }

    if (currentState.currentQuestionIndex >=
        currentState.questions.length - 1) {
      return;
    }

    emit(
      currentState.copyWith(
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        validationError: null,
      ),
    );
  }

  void goToPreviousQuestion() {
    final currentState = state;
    if (currentState is! AssignmentsLoaded) {
      return;
    }

    if (currentState.currentQuestionIndex <= 0) {
      return;
    }

    emit(
      currentState.copyWith(
        currentQuestionIndex: currentState.currentQuestionIndex - 1,
        validationError: null,
      ),
    );
  }

  Future<void> submitCurrentAssignment() async {
    final currentState = state;
    if (currentState is! AssignmentsLoaded) {
      return;
    }

    if (currentState.selectedAnswers.length != currentState.questions.length) {
      emit(
        currentState.copyWith(
          validationError: SettingsStrings.answerAllQuestionsBeforeSubmitting,
        ),
      );
      return;
    }

    final answers = currentState.selectedAnswers.entries
        .map(
          (entry) => AssignmentEntity.answer(
            questionId: entry.key,
            selectedOption: entry.value,
          ),
        )
        .toList();

    emit(const AssignmentsSubmitting());

    final submissionResult = await submitAssignmentUseCase(
      SubmitAssignmentParams(answers: answers),
    );

    await submissionResult.fold(
      (failure) async => emit(AssignmentsError(failure.errorMessage)),
      (result) async {
        await AssignmentVisibilityStore.markAssignmentCompleted();
        final doctors = await _resolveRecommendedDoctors(result);
        emit(AssignmentsResultLoaded(result: result, doctors: doctors));
      },
    );
  }

  Future<List<DoctorEntity>> _resolveRecommendedDoctors(
    AssignmentEntity result,
  ) async {
    final Map<String, DoctorEntity> uniqueDoctors = {};

    if (result.recommendedDoctorIds.isNotEmpty) {
      final allDoctorsResult = await getAllDoctorsUseCase(NoParams());
      allDoctorsResult.fold((_) {}, (doctors) {
        for (final doctor in doctors) {
          if (result.recommendedDoctorIds.contains(doctor.id)) {
            uniqueDoctors[doctor.id] = doctor;
          }
        }
      });
    }

    final specialties = result.recommendedSpecialties.isNotEmpty
        ? result.recommendedSpecialties
        : [_severityFallbackSpecialty(result.severity)];

    for (final specialty in specialties) {
      final doctorsResult = await getDoctorsBySpecialtyUseCase(
        GetDoctorsBySpecialtyParams(specialty: specialty),
      );

      doctorsResult.fold((_) {}, (doctors) {
        for (final doctor in doctors) {
          uniqueDoctors[doctor.id] = doctor;
        }
      });
    }

    return uniqueDoctors.values.toList();
  }

  String _severityFallbackSpecialty(String severity) {
    final normalized = severity.toLowerCase();

    if (normalized.contains('severe') || normalized.contains('high')) {
      return PsychologySpecialties.psychiatrist;
    }

    if (normalized.contains('moderate') || normalized.contains('medium')) {
      return PsychologySpecialties.clinicalPsychologist;
    }

    return PsychologySpecialties.counselor;
  }

  Future<void> retakeAssignment() async {
    await loadQuestions();
  }
}
