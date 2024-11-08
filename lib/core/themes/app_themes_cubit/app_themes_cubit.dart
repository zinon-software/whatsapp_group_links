import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'app_themes_state.dart';

class AppThemesCubit extends Cubit<AppThemesState> {
  AppThemesCubit() : super(AppThemesInitial());

  static AppThemesCubit get(context) => BlocProvider.of(context);

  late ThemeMode themeMode = getThemeMode();

  changeTheme(bool darkModeEnable) {
    emit(AppThemesInitial());
    if (darkModeEnable) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    emit(ChangeThemeModeState());
  }

  ThemeMode getThemeMode() {
    // bool? darkMode =
    //     instance<StorageRepository>().getData(key: keyDarkMode) ?? false;
    // if (darkMode == null) return ThemeMode.system;
    // if (darkMode) return ThemeMode.dark;

    return ThemeMode.light;
  }
}
