import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feeling_state.dart';

class FeelingCubit extends Cubit<FeelingState> {
  FeelingCubit() : super(FeelingInitial());
}
