import 'package:bloc/bloc.dart';
import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/feeling/domain/entities/feeling_entry_entity.dart';
import 'package:afiete/feature/feeling/domain/usecase/feeling_usecases.dart';
import 'package:equatable/equatable.dart';

part 'feeling_state.dart';

class FeelingCubit extends Cubit<FeelingState> {
  final SaveFeelingUseCase saveFeelingUseCase;
  final GetCurrentFeelingUseCase getCurrentFeelingUseCase;
  final GetFeelingHistoryUseCase getFeelingHistoryUseCase;

  FeelingCubit(
    this.saveFeelingUseCase,
    this.getCurrentFeelingUseCase,
    this.getFeelingHistoryUseCase,
  ) : super(FeelingInitial());

  Future<void> loadFeelingHub() async {
    emit(FeelingLoading());

    final currentResult = await getCurrentFeelingUseCase(NoParams());
    final historyResult = await getFeelingHistoryUseCase(
      const GetFeelingHistoryParams(limit: 30),
    );

    final selectedFeeling = currentResult.fold(
      (_) => null,
      (feeling) => feeling,
    );
    final history = historyResult.fold(
      (_) => <FeelingEntryEntity>[],
      (items) => items,
    );

    emit(FeelingLoaded(selectedFeeling: selectedFeeling, history: history));
  }

  Future<void> selectFeeling(FeelingType feeling, {int intensity = 3}) async {
    final currentState = state;
    final previousHistory = currentState is FeelingLoaded
        ? currentState.history
        : <FeelingEntryEntity>[];

    emit(FeelingLoaded(selectedFeeling: feeling, history: previousHistory));

    final saveResult = await saveFeelingUseCase(
      SaveFeelingParams(feeling: feeling, intensity: intensity),
    );

    final historyResult = await getFeelingHistoryUseCase(
      const GetFeelingHistoryParams(limit: 30),
    );

    saveResult.fold(
      (failure) => emit(
        FeelingError(
          failure.errorMessage,
          selectedFeeling: feeling,
          history: previousHistory,
        ),
      ),
      (_) {
        final history = historyResult.fold(
          (_) => previousHistory,
          (items) => items,
        );
        emit(FeelingLoaded(selectedFeeling: feeling, history: history));
      },
    );
  }
}
