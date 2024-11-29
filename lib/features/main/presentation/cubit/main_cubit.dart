import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkati/features/main/data/repositories/main_repositories.dart';

import '../../../../core/widgets/toast_widget.dart';
import '../../data/models/slideshow_model.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainRepository repository;
  List<SlideshowModel> slideshows = [];

  MainCubit({required this.repository}) : super(MainInitial());

  void fetchLocalSlideshowsEvint() {
    emit(SlideshowsLoadingState());

    (repository.getSlideshows()).fold(
      (error) => emit(SlideshowsErrorState(error)),
      (data) {
        slideshows = data;
        emit(SlideshowsSuccessState(data));
      },
    );
  }

  void fetchRemoteSlideshowsEvint() async {
    emit(SlideshowsLoadingState());

    (await repository.fetchSlideshows()).fold(
      (error) => emit(SlideshowsErrorState(error)),
      (data) {
        slideshows = data;
        emit(SlideshowsSuccessState(data));
      },
    );
  }

  void updateSlideshowEvint(SlideshowModel slideshow) async {
    emit(ManageSlideshowLoadingState());

    (await repository.updateSlideshow(slideshow)).fold(
      (error) => emit(ManageSlideshowErrorState(error)),
      (data) {
        emit(ManageSlideshowSuccessState(data));
        fetchRemoteSlideshowsEvint();
      },
    );
  }

  void createSlideshowEvint(SlideshowModel slideshow) async {
    emit(ManageSlideshowLoadingState());

    (await repository.createSlideshow(slideshow)).fold(
      (error) => emit(ManageSlideshowErrorState(error)),
      (data) {
        emit(ManageSlideshowSuccessState(data));
        fetchRemoteSlideshowsEvint();
      },
    );
  }

  void viewSlideshowDetailsEvint(SlideshowModel slideshow) async {
    emit(SlideshowsLoadingState());
    emit(ViewSlideshowDetailsState(slideshow));
  }


  
  bool backButtonPressedOnce = false;
  bool onWillPop(BuildContext context) {
    if (Navigator.canPop(context)) {
      return true;
    }
    Future.delayed(const Duration(seconds: 1), () {
      backButtonPressedOnce = false;
    });

    if (!backButtonPressedOnce) {
      // إذا تم النقر مرتين بسرعة على زر الرجوع
      showToast(
        "اضغط مرة أخرى للخروج من التطبيق",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
      );

      backButtonPressedOnce = true;
      return false;
    }

    // إذا تم النقر مرة واحدة فقط على زر الرجوع
    backButtonPressedOnce = false;
    return true;
  }

}
