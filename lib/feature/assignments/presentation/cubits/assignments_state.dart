part of 'assignments_cubit.dart';

abstract class AssignmentsState extends Equatable {
  const AssignmentsState();

  @override
  List<Object?> get props => [];
}

class AssignmentsInitial extends AssignmentsState {
  const AssignmentsInitial();
}

class AssignmentsLoading extends AssignmentsState {
  const AssignmentsLoading();
}

class AssignmentsLoaded extends AssignmentsState {
  final List<AssignmentEntity> questions;
  final Map<String, String> selectedAnswers;
  final int currentQuestionIndex;
  final String? validationError;

  const AssignmentsLoaded({
    required this.questions,
    required this.selectedAnswers,
    required this.currentQuestionIndex,
    this.validationError,
  });

  AssignmentEntity get currentQuestion => questions[currentQuestionIndex];

  AssignmentsLoaded copyWith({
    List<AssignmentEntity>? questions,
    Map<String, String>? selectedAnswers,
    int? currentQuestionIndex,
    String? validationError,
  }) {
    return AssignmentsLoaded(
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      validationError: validationError,
    );
  }

  @override
  List<Object?> get props => [
    questions,
    selectedAnswers,
    currentQuestionIndex,
    validationError,
  ];
}

class AssignmentsSubmitting extends AssignmentsState {
  const AssignmentsSubmitting();
}

class AssignmentsResultLoaded extends AssignmentsState {
  final AssignmentEntity result;
  final List<DoctorEntity> doctors;

  const AssignmentsResultLoaded({required this.result, required this.doctors});

  @override
  List<Object?> get props => [result, doctors];
}

class AssignmentsError extends AssignmentsState {
  final String message;

  const AssignmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
