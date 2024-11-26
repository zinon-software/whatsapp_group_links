import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../config/app_hive_config.dart';
import '../../../../config/app_injector.dart';
import '../../../../core/storage/storage_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/users_repositories.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository repository;
  final FirebaseAuth auth;

  UserModel? currentUser;

  UsersCubit({required this.repository, required this.auth})
      : super(UsersInitialState());

  FutureOr<void> fetchMyUserAccount({bool isEdit = false}) async {
    try {
      if (auth.currentUser == null) {
        return;
      }
      final uid = auth.currentUser!.uid;

      currentUser = repository.getUser(uid);

      currentUser ??= UserModel.isEmpty().copyWith(
        id: auth.currentUser!.uid,
        email: auth.currentUser!.email,
        name: auth.currentUser!.displayName,
        photoUrl: auth.currentUser!.photoURL,
        phoneNumber: auth.currentUser!.phoneNumber,
      );
      
      emit(UserSuccessState());

      (await repository.fetchUser(uid)).fold(
        (error) => null,
        (response) {
          currentUser = response;

          emit(UserSuccessState());
          if (isEdit) {
            repository.updateUser(response);
          }

          // save isStopAds local storage
          instance<StorageRepository>().setData(
            key: AppHiveConfig.instance.keyIsStopAds,
            value: response.isStopAds,
          );
        },
      );
      if (!isEdit) {
        repository.updateUser(
          currentUser!.copyWith(
            lastLoginAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      // rethrow;
    }
  }

  void onSignInWithGoogleEvent() async {
    emit(SignInWithGoogleLoadingState());

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        auth.currentUser?.reload();
        onCreateUser(auth.currentUser!.uid);
      } else {
        auth.currentUser?.reload();
        await fetchMyUserAccount(isEdit: true);
      }

      emit(LoginRouteToHomeState());
    } on PlatformException catch (e) {
      emit(SignInWithGoogleErrorState(error: '${e.message} ${e.code}'));
    } catch (e) {
      emit(SignInWithGoogleErrorState(error: '$e ${e.hashCode}'));
    }
  }

  Future<void> onCreateUser(String uid) async {
    currentUser = UserModel(
      id: uid,
      name: auth.currentUser!.displayName ?? 'No Name',
      email: auth.currentUser!.email ?? 'No Email',
      photoUrl: auth.currentUser!.photoURL ?? '',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      phoneNumber: auth.currentUser!.phoneNumber ?? '',
      permissions: PermissionModel(),
    );

    repository.createUser(currentUser!);
  }

  Future<void> onUpdateUser(UserModel user) async {
    emit(UpdateUserLoadingState());

    (await repository.updateUser(user)).fold(
      (failure) {
        emit(UpdateUserErrorState(failure));
      },
      (response) {
        currentUser = user;
        emit(UpdateUserSuccessState(response));
      },
    );
  }

  void signOut() {
    auth.signOut();

    currentUser = null;
    auth.currentUser?.reload();

    GoogleSignIn().signOut();

    emit(LogoutRouteToLoginState());
  }

  void incrementScoreEvent({int score = 1}) async {
    (await repository.incrementScore(auth.currentUser!.uid, score)).fold(
      (error) => null,
      (user) {
        currentUser = user;
        emit(UsersInitialState());
        emit(UserSuccessState());
      },
    );
  }

  void fetchUsersEvent() async {
    emit(FetchUsersLoadingState());
    (await repository.fetchUsers()).fold(
      (error) => emit(FetchUsersErrorState(error)),
      (data) => emit(FetchUsersSuccessState(data)),
    );
  }

  void fetchUserEvent({required String userId, required String query}) async {
    emit(FetchUserLoadingState(userId: userId, query: query));
    (await repository.fetchUser(userId)).fold(
      (error) => emit(FetchUserErrorState(
        error: error,
        userId: userId,
        query: query,
      )),
      (data) => emit(FetchUserSuccessState(
        user: data,
        query: query,
      )),
    );
  }
}
