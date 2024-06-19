part of 'theme_bloc.dart';

@freezed
sealed class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.themeModeChanged(
    ThemeMode themeMode,
  ) = ThemeModeChanged;
}
