part of 'feeling_cubit.dart';

abstract class FeelingState extends Equatable {
  const FeelingState();

  @override
  List<Object?> get props => [];
}

class FeelingInitial extends FeelingState {}

class FeelingLoading extends FeelingState {}

class FeelingLoaded extends FeelingState {
  final FeelingType? selectedFeeling;
  final List<FeelingEntryEntity> history;

  const FeelingLoaded({required this.selectedFeeling, required this.history});

  @override
  List<Object?> get props => [selectedFeeling, history];
}

class FeelingError extends FeelingState {
  final String message;
  final FeelingType? selectedFeeling;
  final List<FeelingEntryEntity> history;

  const FeelingError(
    this.message, {
    required this.selectedFeeling,
    required this.history,
  });

  @override
  List<Object?> get props => [message, selectedFeeling, history];
}
