import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../../core/widgets/custom_skeletonizer_widget.dart';
import '../cubit/users_cubit.dart';

class LoadUserWidget extends StatefulWidget {
  const LoadUserWidget({super.key, required this.userId, required this.query});
  final String userId;
  final String query;

  @override
  State<LoadUserWidget> createState() => _LoadUserWidgetState();
}

class _LoadUserWidgetState extends State<LoadUserWidget> {
  late final UsersCubit _usersCubit;

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _usersCubit = context.read<UsersCubit>();
    _user = _usersCubit.repository.getUser(widget.userId);
    if (_user == null) {
      _usersCubit.fetchUserEvent(userId: widget.userId, query: widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: _usersCubit,
      buildWhen: (previous, current) {
        if (_user != null) return false;
        if (current is FetchUserSuccessState) {
          return current.query == widget.query &&
              current.user.id == widget.userId;
        }
        if (current is FetchUserErrorState) {
          return current.query == widget.query &&
              current.userId == widget.userId;
        }
        if (current is FetchUserLoadingState) {
          return current.query == widget.query &&
              current.userId == widget.userId;
        }
        return false;
      },
      builder: (context, state) {
        if (state is FetchUserErrorState && _user == null) {
          return Text(state.error);
        }
        if (state is FetchUserLoadingState && _user == null) {
          return CustomSkeletonizerWidget(
            enabled: true,
            child: UserWidget(user: UserModel.isEmpty()),
          );
        }
        if (state is FetchUserSuccessState &&
            state.user.id == widget.userId &&
            state.query == widget.query) {
          _user = state.user;
        }
        return UserWidget(user: _user!);
      },
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorsManager.primaryLight,
            child: CustomCachedNetworkImage(
              user.photoUrl,
              width: 40,
              height: 40,
              borderRadius: 20,
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "آخر ظهور: ${user.lastLoginAt.formatTimeAgoString()}",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
