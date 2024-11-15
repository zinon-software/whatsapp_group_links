import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../users/data/models/user_model.dart';

class UsersRankScreen extends StatefulWidget {
  const UsersRankScreen({super.key});

  @override
  State<UsersRankScreen> createState() => _UsersRankScreenState();
}

class _UsersRankScreenState extends State<UsersRankScreen> {
  late final UsersCubit _usersCubit;

  @override
  void initState() {
    super.initState();
    _usersCubit = context.read<UsersCubit>();

    _usersCubit.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اقسام التحديات"),
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        bloc: _usersCubit,
        builder: (context, state) {
          if (state is FetchUsersLoadingState) {
            return const Center(
              child:
                  CircularProgressIndicator(color: ColorsManager.primaryLight),
            );
          }

          if (state is FetchUsersErrorState) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is FetchUsersSuccessState) {
            List<UserModel> users = [];

            users.addAll(state.users);

            users.sort((a, b) => b.score.compareTo(a.score));

            UserModel topOneUser = users[0];

            users.remove(topOneUser);
            UserModel topTwoUser = users[0];

            users.remove(topTwoUser);
            UserModel topThreeUser = users[0];

            users.remove(topThreeUser);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 230,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: UserRankCard(
                          user: topTwoUser,
                          rank: 2,
                        ),
                      ), // المرتبة الثانية
                      Expanded(
                        child: UserRankCard(
                          user: topOneUser,
                          rank: 1,
                        ),
                      ), // المرتبة الأولى
                      Expanded(
                        child: UserRankCard(
                          user: topThreeUser,
                          rank: 3,
                        ),
                      ), // المرتبة الثالثة
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ColorsManager.primaryLight,
                          child: Text(
                            user.name.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.country ?? ''),
                        trailing: Text("+${user.score}"),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}

class UserRankCard extends StatelessWidget {
  final UserModel user;
  final int rank;

  const UserRankCard({
    super.key,
    required this.user,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    // اختيار الرمز التعبيري بناءً على المرتبة
    final rankEmoji = rank == 1
        ? '👑'
        : rank == 2
            ? '🥈'
            : '🥉';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage:
                      CustomCachedNetworkImage(user.photoUrl).imageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      rankEmoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (user.country != null)
              Text(
                user.country!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: rank == 1
                    ? ColorsManager.primaryLight
                    : rank == 2
                        ? ColorsManager.primaryDark
                        : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${user.score} نقطة',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
