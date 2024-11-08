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
