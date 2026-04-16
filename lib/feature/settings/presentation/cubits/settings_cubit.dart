import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/domin/usecase/get_medical_profile_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/share_medical_note_with_doctor_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/submit_report_issue_usecase.dart';
import 'package:afiete/feature/settings/domin/usecase/update_medical_note_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetMedicalProfileUseCase getMedicalProfileUseCase;
  final SubmitReportIssueUseCase submitReportIssueUseCase;
  final UpdateMedicalNoteUseCase updateMedicalNoteUseCase;
  final ShareMedicalNoteWithDoctorUseCase shareMedicalNoteWithDoctorUseCase;

  MedicalProfileEntity? _currentProfile;

  SettingsCubit(
    this.getMedicalProfileUseCase,
    this.submitReportIssueUseCase,
    this.updateMedicalNoteUseCase,
    this.shareMedicalNoteWithDoctorUseCase,
  ) : super(const SettingsInitial());

  MedicalProfileEntity? get currentProfile => _currentProfile;

  Future<void> loadMedicalProfile(String userId) async {
    final safeUserId = userId.isEmpty ? 'mock-user' : userId;

    emit(const SettingsLoading());
    final result = await getMedicalProfileUseCase(safeUserId);
    result.fold((failure) => emit(SettingsError(failure.errorMessage)), (
      profile,
    ) {
      _currentProfile = profile;
      emit(SettingsLoaded(profile));
    });
  }

  Future<String?> updateMedicalNote({
    required String userId,
    required String noteTitle,
    required String previousUpdatedAt,
    required String newTitle,
    required String newContent,
  }) async {
    final safeUserId = userId.isEmpty ? 'mock-user' : userId;

    final result = await updateMedicalNoteUseCase(
      UpdateMedicalNoteParams(
        userId: safeUserId,
        noteTitle: noteTitle,
        previousUpdatedAt: previousUpdatedAt,
        newTitle: newTitle,
        newContent: newContent,
      ),
    );

    return result.fold(
      (failure) {
        emit(SettingsError(failure.errorMessage));
        return failure.errorMessage;
      },
      (profile) {
        _currentProfile = profile;
        emit(SettingsLoaded(profile));
        return null;
      },
    );
  }

  Future<String> shareMedicalNoteWithDoctor({
    required String userId,
    required String noteTitle,
    required String noteContent,
    required String doctorId,
  }) async {
    final safeUserId = userId.isEmpty ? 'mock-user' : userId;

    final result = await shareMedicalNoteWithDoctorUseCase(
      ShareMedicalNoteWithDoctorParams(
        userId: safeUserId,
        noteTitle: noteTitle,
        noteContent: noteContent,
        doctorId: doctorId,
      ),
    );

    return result.fold(
      (failure) {
        emit(SettingsError(failure.errorMessage));
        return failure.errorMessage;
      },
      (message) {
        return message;
      },
    );
  }

  Future<void> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  }) async {
    if (userId.isEmpty) {
      emit(const SettingsError('Missing user information.'));
      return;
    }

    emit(const SettingsSubmittingReport());
    final result = await submitReportIssueUseCase(
      SubmitReportIssueParams(userId: userId, reason: reason, details: details),
    );
    result.fold(
      (failure) => emit(SettingsError(failure.errorMessage)),
      (message) => emit(SettingsReportSubmitted(message)),
    );
  }
}
