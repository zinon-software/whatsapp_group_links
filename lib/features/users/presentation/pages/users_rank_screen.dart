import 'package:flutter/material.dart';
import 'package:linkati/core/utils/color_manager.dart';

import '../../../../core/widgets/custom_cached_network_image_widget.dart';
import '../../../users/data/models/user_model.dart';

class UsersRankScreen extends StatelessWidget {
  const UsersRankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة المستخدمين الثلاثة
    final users = [
      UserModel(
        id: '1',
        name: 'User One',
        email: 'user1@example.com',
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        phoneNumber: '1234567890',
        permissions: PermissionModel(),
        score: 300,
        country: 'Country A',
      ),
      UserModel(
        id: '2',
        name: 'User Two',
        email: 'user2@example.com',
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        phoneNumber: '1234567890',
        permissions: PermissionModel(),
        score: 250,
        country: 'Country B',
      ),
      UserModel(
        id: '3',
        name: 'User Three',
        email: 'user3@example.com',
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        phoneNumber: '1234567890',
        permissions: PermissionModel(),
        score: 200,
        country: 'Country C',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("اقسام التحديات"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UserRankCard(user: users[1], rank: 2), // المرتبة الثانية
                UserRankCard(user: users[0], rank: 1), // المرتبة الأولى
                UserRankCard(user: users[2], rank: 3), // المرتبة الثالثة
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Text('4 🥉', style: TextStyle(fontSize: 20)),
                  title: Text("Olivia Harper"),
                  subtitle: Text("@oliviahrp"),
                  trailing: Text("+300"),
                ),
                ListTile(
                  leading: const Text('5 🏅', style: TextStyle(fontSize: 20)),
                  title: Text("Sophia Benhet"),
                  subtitle: Text("@sophiabnt12"),
                  trailing: Text("+282"),
                ),
              ],
            ),
          ),
        ],
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

    return Stack(
      // mainAxisAlignment: MainAxisAlignment.end,
      alignment: Alignment.center,
      children: [
        // صندوق مضلع مع تدرج لوني
        Column(
          children: [
            Spacer(),
            ClipPath(
              clipper: PolygonClipper(),
              child: Container(
                height: 60 / rank + 60,
                width: MediaQuery.sizeOf(context).width / 3.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryLight,
                      ColorManager.primaryDark
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Text(
                      '$rank',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30 / rank + 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8 + rank.toDouble()),
          ],
        ),

        Positioned(
          top: rank == 3
              ? 33
              : rank == 2
                  ? 25
                  : 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: CustomCachedNetworkImage(user.photoUrl).imageProvider,
              ),
              Positioned(
                top: -9,
                right: -3,
                child: Text(rankEmoji, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
        Positioned(
          top: rank == 3
              ? 95
              : rank == 2
                  ? 90
                  : 65,
          child: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        if (user.country != null)
          Positioned(
            top: rank == 3
                ? 115
                : rank == 2
                    ? 108
                    : 85,
            child: Text(user.country!, style: const TextStyle(fontSize: 12)),
          ),
        const SizedBox(height: 4),
        Positioned(
          top: rank == 3
              ? 135
              : rank == 2
                  ? 128
                  : 105,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Text(
              '+${user.score}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class PolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // تقليل ارتفاع الجزء العلوي ليكون أقصر
    path.moveTo(0, size.height * 0.3); // نقطة البداية منخفضة قليلاً
    path.lineTo(size.width * 0.15, size.height * 0.2); // تقليل ارتفاع الزاوية
    path.lineTo(
        size.width * 0.85, size.height * 0.2); // تقليل ارتفاع الزاوية الأخرى
    path.lineTo(size.width, size.height * 0.3); // نهاية المنحدر العلوي

    // الجوانب العمودية
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
