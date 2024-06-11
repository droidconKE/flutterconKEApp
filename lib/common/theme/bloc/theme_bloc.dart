import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../data/repository/local_storage.dart';
import '../../../di/injectable.dart';
import '../../utils/constants/pref_constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

enum ThemeType { system, light, dark, pureBlack }

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) =>
      droppable<E>().call(events.throttle(duration), mapper);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeChangeEvent>(
      _themeChangeEvent,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _themeChangeEvent(
      ThemeChangeEvent event, Emitter<ThemeState> emit) async {
    try {
      emit(state.copyWith(status: ThemeStatus.loading));
      var localStorage = getIt<LocalStorage>();

      ThemeType themeType =
          ThemeType.values[localStorage.getPrefInt(PrefConstants.appThemeKey)];
      //CustomThemeType selectedTheme = CustomThemeType.values.byName(prefs.getString(LocalSettings.appThemeAccentColor.name) ?? CustomThemeType.deepBlue.name);

      bool useMaterialYouTheme =
          true; //prefs.getBool(LocalSettings.useMaterialYouTheme.name) ?? false;

      // Fetch reduce animations preferences to remove overscrolling effects
      //bool reduceAnimations = prefs.getBool(LocalSettings.reduceAnimations.name) ?? false;

      // Check what the system theme is (light/dark)
      Brightness brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      bool useDarkTheme = themeType != ThemeType.light;
      if (themeType == ThemeType.system) {
        useDarkTheme = brightness == Brightness.dark;
      }

      return emit(
        state.copyWith(
          status: ThemeStatus.success,
          themeType: themeType,
          useMaterialYouTheme: useMaterialYouTheme,
          useDarkTheme: useDarkTheme,
          reduceAnimations: true, //reduceAnimations,
        ),
      );
    } catch (e) {
      return emit(state.copyWith(status: ThemeStatus.failure));
    }
  }
}
