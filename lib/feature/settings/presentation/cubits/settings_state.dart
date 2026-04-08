part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final MedicalProfileEntity medicalProfile;

  const SettingsLoaded(this.medicalProfile);

  @override
  List<Object?> get props => [medicalProfile];
}

class SettingsSubmittingReport extends SettingsState {
  const SettingsSubmittingReport();
}

class SettingsReportSubmitted extends SettingsState {
  final String message;

  const SettingsReportSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
