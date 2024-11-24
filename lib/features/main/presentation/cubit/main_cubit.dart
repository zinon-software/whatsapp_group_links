import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/features/main/data/repositories/main_repositories.dart';

import '../../data/models/slideshow_model.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainRepository repository;
  MainCubit({required this.repository}) : super(MainInitial());

  void fetchSlideshowsEvint() async {
    emit(SlideshowsLoadingState());

    (await repository.fetchSlideshows()).fold(
      (error) => emit(SlideshowsErrorState(error)),
      (data) => emit(SlideshowsSuccessState(data)),
    );
  }

  void updateSlideshowEvint(SlideshowModel slideshow) async {
    emit(ManageSlideshowLoadingState());

    (await repository.updateSlideshow(slideshow)).fold(
      (error) => emit(ManageSlideshowErrorState(error)),
      (data) {
        emit(ManageSlideshowSuccessState(data));
        fetchSlideshowsEvint();
      },
    );
  }

  void createSlideshowEvint(SlideshowModel slideshow) async {
    emit(ManageSlideshowLoadingState());

    (await repository.createSlideshow(slideshow)).fold(
      (error) => emit(ManageSlideshowErrorState(error)),
      (data) {
        emit(ManageSlideshowSuccessState(data));
        fetchSlideshowsEvint();
      },
    );
  }

  void viewSlideshowDetailsEvint(SlideshowModel slideshow) async {
    emit(SlideshowsLoadingState());
    emit(ViewSlideshowDetailsState(slideshow));
  }
}
