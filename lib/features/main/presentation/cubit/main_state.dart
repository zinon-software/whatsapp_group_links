part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class SlideshowsSuccessState extends MainState {
  final List<SlideshowModel> slideshows;

  const SlideshowsSuccessState(this.slideshows);
}

class SlideshowsErrorState extends MainState {
  final String message;

  const SlideshowsErrorState(this.message);
}

class SlideshowsLoadingState extends MainState {}

class ManageSlideshowSuccessState extends MainState {
  final String message;

  const ManageSlideshowSuccessState(this.message);
}

class ManageSlideshowErrorState extends MainState {
  final String message;

  const ManageSlideshowErrorState(this.message);
}

class ManageSlideshowLoadingState extends MainState {}