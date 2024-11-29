import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/notification/send_notification.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/link_model.dart';
import '../../data/repositories/links_repositories.dart';

part 'links_state.dart';

class LinksCubit extends Cubit<LinksState> {
  final LinksRepository repository;

  LinksCubit({required this.repository}) : super(LinksInitialState());

  void createLinkEvent(LinkModel newLink) async {
    emit(CreateLinkLoadingState());

    (await repository.createLink(newLink)).fold((failure) {
      emit(CreateLinkErrorState(failure));
    }, (response) {
      Map<String, dynamic> data = {
        "link": jsonEncode(response.toStringData()), // تحويل الكائن إلى نص JSON
        "route": AppRoutes.linkDetailsRoute,
      };

      sendFCMMessageToAllUsers(
        title: 'تم انشاء رابط ${determinePlatform(response.url)} جديد',
        body: newLink.title,
        data: data,
      );

      emit(CreateLinkSuccessState("تم انشاء رابط جديد"));
    });
  }

  void updateLinkEvent(LinkModel newLink) async {
    emit(CreateLinkLoadingState());

    (await repository.updateLink(newLink)).fold((failure) {
      emit(CreateLinkErrorState(failure));
    }, (response) {
      emit(CreateLinkSuccessState(response));
    });
  }

  void createBannedWordEvent(String word) async {
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

  void deleteBannedWordEvent(String word) async {
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

  void changeLinkActiveEvent(String id, bool isActive) async {
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

  void deleteLinkEvent(String id) async {
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

  Future<void> checkBannedWordEvent(String word) async {
    emit(CheckBannedWordLoadingState());
    (await repository.checkBannedWord(word)).fold(
      (failure) {
        emit(CheckBannedWordErrorState(failure));
      },
      (response) {
        if (response) {
          emit(
            CheckBannedWordErrorState("هذا الرابط يحتوي على محتوى غير لائق"),
          );
        } else {
          emit(CheckBannedWordSuccessState(
            "هذا الرابط لا يحتوي على محتوى غير لائق",
          ));
        }
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
