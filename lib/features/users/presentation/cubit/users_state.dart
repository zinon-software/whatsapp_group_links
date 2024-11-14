part of 'users_cubit.dart';

abstract class UsersState {
  const UsersState();
}

class UsersInitialState extends UsersState {
  const UsersInitialState();
}

class UserSuccessState extends UsersState {
  const UserSuccessState();
}

class SignInWithGoogleLoadingState extends UsersState {
  const SignInWithGoogleLoadingState();
}

class SignInWithGoogleErrorState extends UsersState {
  String error;
  SignInWithGoogleErrorState({required this.error});
}

class LoginRouteToHomeState extends UsersState {
  const LoginRouteToHomeState();
}

class LogoutRouteToLoginState extends UsersState {
  const LogoutRouteToLoginState();
}

class FetchPlayerUserLoadingState extends UsersState {
  final String userId, gameId;
  const FetchPlayerUserLoadingState({required this.userId, required this.gameId});
}

class FetchPlayerUserSuccessState extends UsersState {
  final String gameId;
  final UserModel user;
  const FetchPlayerUserSuccessState({required this.user, required this.gameId,});
}

class FetchPlayerUserErrorState extends UsersState {
  final String userId, gameId;
  final String error;
  const FetchPlayerUserErrorState({required this.error, required this.userId, required this.gameId,});
}
