import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_event.dart';
part 'theme_state.dart';

part 'theme_bloc.freezed.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system) {
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  Stream<ThemeMode> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeMode> mode,
  ) async* {
    yield event.themeMode;
  }
}
