import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  MusicCubit() : super(MusicInitial());
}
