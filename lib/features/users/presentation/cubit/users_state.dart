part of 'users_cubit.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

final class UsersInitialState extends UsersState {
  UsersInitialState();
}

class SignInWithGoogleLoadingState extends UsersState {
  const SignInWithGoogleLoadingState();
}

class SignInWithGoogleErrorState extends UsersState {
  final String error;
  const SignInWithGoogleErrorState({required this.error});
}

class LoginRouteToHomeState extends UsersState {
  const LoginRouteToHomeState();
}


