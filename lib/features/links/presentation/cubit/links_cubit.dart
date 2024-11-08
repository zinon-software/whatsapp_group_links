import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/link_model.dart';
import '../../data/repositories/links_repositories.dart';

part 'links_state.dart';

class LinksCubit extends Cubit<LinksState> {
  final LinksRepository repository;

  LinksCubit({required this.repository}) : super(LinksInitialState());

  void createLink(LinkModel newLink) async {
    emit(CreateLinkLoadingState());

    (await repository.createLink(newLink)).fold((failure) {
      emit(CreateLinkErrorState(failure));
    }, (response) {
      emit(CreateLinkSuccessState(response));
    });
  }

  void createBannedWord(String word) async {
    emit(CreateBannedWordLoadingState());

    (await repository.createBannedWord(word)).fold(
      (failure) {
        emit(CreateBannedWordErrorState(failure));
      },
      (response) {
        emit(CreateBannedWordSuccessState(response));
      },
    );
  }

  void deleteBannedWord(String word) async {
    emit(ManageLinkLoadingState());

    (await repository.deleteBannedWord(word)).fold(
      (failure) {
        emit(ManageLinkErrorState(failure));
      },
      (response) {
        emit(ManageLinkSuccessState(response));
      },
    );
  }

  void changeLinkActive(String id, bool isActive)async {
    emit(ManageLinkLoadingState());

    (await repository.changeLinkActive(id, isActive)).fold(
      (failure) {
        emit(ManageLinkErrorState(failure));
      },
      (response) {
        emit(ManageLinkSuccessState(response));
      },
    );
  }

  String determineType(String url) {
    if (url.contains("facebook")) {
      return "facebook";
    } else if (url.contains("twitter") || url.contains("x")) {
      return "twitter";
    } else if (url.contains("whatsapp")) {
      return "whatsapp";
    } else if (url.contains("telegram")) {
      return "telegram";
    } else if (url.contains("instagram")) {
      return "instagram";
    } else if (url.contains("snapchat")) {
      return "snapchat";
    } else if (url.contains("tiktok")) {
      return "tiktok";
    } else if (url.contains("linkedin")) {
      return "linkedin";
    } else {
      return "other";
    }
  }
}
