import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../common/theme/bloc/theme_bloc.dart';
import '../../common/utils/constants/app_constants.dart';

part 'fluttercon_event.dart';

part 'fluttercon_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) =>
      droppable<E>().call(events.throttle(duration), mapper);
}

class FlutterconBloc extends Bloc<FlutterconEvent, FlutterconState> {
  FlutterconBloc() : super(const FlutterconState()) {
    on<InitializeAppEvent>(
      _initializeAppEvent,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPreferencesChangeEvent>(
      _userPreferencesChangeEvent,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _initializeAppEvent(
      InitializeAppEvent event, Emitter<FlutterconState> emit) async {
    try {
      add(UserPreferencesChangeEvent());
      emit(state.copyWith(status: FlutterconStatus.success));
    } catch (e) {
      return emit(state.copyWith(
          status: FlutterconStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _userPreferencesChangeEvent(
      UserPreferencesChangeEvent event, Emitter<FlutterconState> emit) async {
    try {
      emit(state.copyWith(status: FlutterconStatus.refreshing));
    } catch (e) {
      return emit(state.copyWith(
          status: FlutterconStatus.failure, errorMessage: e.toString()));
    }
  }
}
