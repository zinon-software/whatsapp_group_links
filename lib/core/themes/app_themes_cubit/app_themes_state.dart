part of 'app_themes_cubit.dart';

abstract class AppThemesState extends Equatable {
  const AppThemesState();

  @override
  List<Object> get props => [];
}

class AppThemesInitial extends AppThemesState {}

class ChangeThemeModeState extends AppThemesState {}
