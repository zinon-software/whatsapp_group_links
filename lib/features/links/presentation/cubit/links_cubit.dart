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

  void updateLink(LinkModel newLink) async {
    emit(CreateLinkLoadingState());

    (await repository.updateLink(newLink)).fold((failure) {
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

  void changeLinkActive(String id, bool isActive) async {
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

  void deleteLink(String id) async {
    emit(ManageLinkLoadingState());

    (await repository.deleteLink(id)).fold(
      (failure) {
        emit(ManageLinkErrorState(failure));
      },
      (response) {
        emit(ManageLinkSuccessState(response));
      },
    );
  }

  String determinePlatform(String url) {
    // تحويل الرابط إلى أحرف صغيرة لتجنب مشاكل حساسية الأحرف
    url = url.toLowerCase();

    // خريطة تحتوي على المنصات والكلمات المفتاحية والدومينات الخاصة بكل منصة
    final platformKeywords = {
      "facebook": ["facebook.com", "fb.com"],
      "twitter": ["twitter.com", "x.com"],
      "whatsapp": ["whatsapp.com", "wa.me"],
      "telegram": ["telegram.org", "t.me"],
      "instagram": ["instagram.com", "instagr.am"],
      "snapchat": ["snapchat.com"],
      "tiktok": ["tiktok.com"],
      "linkedin": ["linkedin.com"],
      "youtube": ["youtube.com", "youtu.be"],
    };

    // التكرار عبر الخريطة للتحقق من الكلمات المفتاحية
    for (var entry in platformKeywords.entries) {
      for (var keyword in entry.value) {
        if (url.contains(keyword)) {
          return entry.key; // إعادة اسم المنصة عند العثور على تطابق
        }
      }
    }

    return "other"; // إذا لم يتم العثور على تطابق، نعيد "other"
  }
}
