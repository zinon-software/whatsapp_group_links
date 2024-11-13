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
  const FetchPlayerUserLoadingState();
}

class FetchPlayerUserSuccessState extends UsersState {
  final UserModel user;
  const FetchPlayerUserSuccessState(this.user);
}

class FetchPlayerUserErrorState extends UsersState {
  final String error;
  const FetchPlayerUserErrorState(this.error);
}
