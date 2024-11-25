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

class FetchUserLoadingState extends UsersState {
  final String userId, query;
  const FetchUserLoadingState({required this.userId, required this.query});
}

class FetchUserSuccessState extends UsersState {
  final String query;
  final UserModel user;
  const FetchUserSuccessState({
    required this.user,
    required this.query,
  });
}

class FetchUserErrorState extends UsersState {
  final String userId, query;
  final String error;
  const FetchUserErrorState({
    required this.error,
    required this.userId,
    required this.query,
  });
}

class UpdateUserLoadingState extends UsersState {
  const UpdateUserLoadingState();
}

class UpdateUserSuccessState extends UsersState {
  final String message;
  const UpdateUserSuccessState(this.message);
}

class UpdateUserErrorState extends UsersState {
  final String error;
  const UpdateUserErrorState(this.error);
}

class FetchUsersLoadingState extends UsersState {
  const FetchUsersLoadingState();
}

class FetchUsersSuccessState extends UsersState {
  final List<UserModel> users;
  const FetchUsersSuccessState(this.users);
}

class FetchUsersErrorState extends UsersState {
  final String error;
  const FetchUsersErrorState(this.error);
}
