import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/users_repositories.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository repository;
  final FirebaseAuth auth;

  UserModel? currentUser;

  UsersCubit({required this.repository, required this.auth})
      : super(UsersInitialState());

  Future<void> fetchMyUserAccount() async {
    try {
      if (auth.currentUser == null) {
        return;
      }
      final uid = auth.currentUser!.uid;
      (await repository.fetchUser(uid)).fold(
        (error) => null,
        (response) {
          currentUser = response;
          emit(UserSuccessState());
        },
      );
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
        await fetchMyUserAccount();
        if (currentUser != null) onUpdateUser(currentUser!);
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
    repository.updateUser(user);

    currentUser = user;

    emit(UserSuccessState());
  }

  void signOut() {
    auth.signOut();

    currentUser = null;
    auth.currentUser?.reload();

    emit(LogoutRouteToLoginState());
  }

  FutureOr<void> fetchPlayerUser(String id) async {
    emit(FetchPlayerUserLoadingState());
    (await repository.fetchUser(id)).fold(
      (error) => emit(FetchPlayerUserErrorState(error)),
      (data) => emit(FetchPlayerUserSuccessState(data)),
    );
  }
}
