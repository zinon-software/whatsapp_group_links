import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/ads/ads_manager.dart';
import 'package:linkati/core/utils/color_manager.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../users/data/models/user_model.dart';

class UsersRankScreen extends StatefulWidget {
  const UsersRankScreen({super.key});

  @override
  State<UsersRankScreen> createState() => _UsersRankScreenState();
}

class _UsersRankScreenState extends State<UsersRankScreen> {
  late final UsersCubit _usersCubit;
  late final AdsManager _adsManager;

  @override
  void initState() {
    super.initState();
    _adsManager = AdsManager();
    _usersCubit = context.read<UsersCubit>();

    _adsManager.loadNativeAd();

    _usersCubit.fetchUsersEvent();
  }

  @override
  void dispose() {
    _adsManager.disposeNativeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الترتيب"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _usersCubit.fetchUsersEvent();
            },
          ),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        bloc: _usersCubit,
        builder: (context, state) {
          if (state is FetchUsersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryLight,
              ),
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

            // ترتيب المستخدمين حسب تاريخ الإنشاء ثم النقاط
            users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            users.sort((a, b) => b.score.compareTo(a.score));

            // التحقق من وجود عناصر كافية 
            UserModel? topOneUser;
            UserModel? topTwoUser;
            UserModel? topThreeUser;

            if (users.isNotEmpty) {
              topOneUser = users[0];
              users.remove(topOneUser);
            }
            if (users.isNotEmpty) {
              topTwoUser = users[0];
              users.remove(topTwoUser);
            }
            if (users.isNotEmpty) {
              topThreeUser = users[0];
              users.remove(topThreeUser);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (topOneUser != null ||
                    topTwoUser != null ||
                    topThreeUser != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 260,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (topTwoUser != null)
                            Expanded(
                              child: TopUserRankCardWidget(
                                isMe: topTwoUser.id ==
                                    _usersCubit.currentUser?.id,
                                user: topTwoUser,
                                rank: 2,
                              ),
                            ),
                          if (topOneUser != null)
                            Expanded(
                              child: TopUserRankCardWidget(
                                isMe: topOneUser.id ==
                                    _usersCubit.currentUser?.id,
                                user: topOneUser,
                                rank: 1,
                              ),
                            ),
                          if (topThreeUser != null)
                            Expanded(
                              child: TopUserRankCardWidget(
                                isMe: topThreeUser.id ==
                                    _usersCubit.currentUser?.id,
                                user: topThreeUser,
                                rank: 3,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final bool isMe = user.id == _usersCubit.currentUser?.id;
                      return Column(
                        children: [
                          if ((index + 1) % 10 == 0)
                            Center(
                              child: _adsManager.getNativeAdWidget(),
                            ),
                          UserRankCardWidget(
                            isMe: isMe,
                            user: user,
                            rank: index + 4,
                          ),
                          if (index == users.length - 1)
                            const SizedBox(height: 100),
                        ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _usersCubit.currentUser == null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                    AppRoutes.loginRoute,
                    arguments: {
                      "next_route": AppRoutes.usersRankRoute,
                    },
                  );
                },
                label: 'تسجيل الدخول',
              ),
            )
          : null,
    );
  }
}

class UserRankCardWidget extends StatelessWidget {
  const UserRankCardWidget({
    super.key,
    required this.isMe,
    required this.user,
    required this.rank,
  });

  final bool isMe;
  final UserModel user;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isMe ? Colors.amber : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        tileColor: isMe ? ColorsManager.primaryLight : null,
        leading: CircleAvatar(
          backgroundColor: ColorsManager.primaryLight,
          child: CustomCachedNetworkImage(
            user.photoUrl,
            width: 50,
            height: 50,
            borderRadius: 25,
          ),
        ),
        title: Text(user.name),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: ColorsManager.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "المرتبة: $rank",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(user.country ?? ''),
          ],
        ),
        trailing: Text("+${user.score}"),
      ),
    );
  }
}

class TopUserRankCardWidget extends StatelessWidget {
  final UserModel user;
  final int rank;
  final bool isMe;

  const TopUserRankCardWidget({
    super.key,
    required this.user,
    required this.rank,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    // اختيار الرمز التعبيري بناءً على المرتبة
    final rankEmoji = rank == 1
        ? '👑'
        : rank == 2
            ? '🥈'
            : '🥉';

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.container,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.aed5e5.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isMe ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
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
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (user.country != null)
              Text(
                user.country!,
                style: const TextStyle(
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
            const SizedBox(height: 8),
            Text(
              'المرتبة: $rank',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
