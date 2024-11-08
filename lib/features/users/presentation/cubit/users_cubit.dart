import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/users_repositories.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository repository;
  final FirebaseAuth auth;

  UserModel? user;

  UsersCubit({required this.repository, required this.auth})
      : super(UsersInitialState());

  void fetchMyUserAccount() async {
    try {
      if (auth.currentUser == null) {
        return;
      }
      final uid = auth.currentUser!.uid;
      (await repository.fetchUser(uid)).fold(
        (error) => null,
        (response) => user = response,
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
        _onSaveUser(auth.currentUser!.uid);
      } else {
        auth.currentUser?.reload();
        _onUpdateUser(auth.currentUser!.uid);
      }

      emit(LoginRouteToHomeState());
    } on PlatformException catch (e) {
      emit(SignInWithGoogleErrorState(error: e.message ?? ''));
    } catch (e) {
      emit(SignInWithGoogleErrorState(error: e.toString()));
    }
  }

  Future<void> _onSaveUser(String uid) async {
    user = UserModel(
      id: uid,
      name: auth.currentUser!.displayName ?? 'No Name',
      email: auth.currentUser!.email ?? 'No Email',
      photoUrl: auth.currentUser!.photoURL ?? '',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      phoneNumber: auth.currentUser!.phoneNumber ?? '',
      permissions: PermissionModel(),
    );

    repository.createUser(user!);
  }

  Future<void> _onUpdateUser(String uid) async {
    (await repository.fetchUser(uid)).fold(
      (error) => null,
      (responce) {
        user = responce;
        repository.updateUser(responce);
      },
    );
  }
}
