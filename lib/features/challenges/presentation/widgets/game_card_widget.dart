import 'package:flutter/material.dart';

import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget(
      {super.key, required this.session, required this.usersCubit,});
  final GameModel session;
  final UsersCubit usersCubit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الجلسة مع رقم الجلسة أو معرّفها
            Text(
              'المبارزة ${session.id}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // عرض اللاعب الأول
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'اللاعب الأول: ${session.player1.userId} - النقاط: ${session.player1.score}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // عرض اللاعب الثاني
            if (session.player2.userId.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'اللاعب الثاني: ${session.player2.userId} - النقاط: ${session.player2.score}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text(
                    'اللاعب الثاني لم ينضم بعد',
                    style: TextStyle(color: Colors.red),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // عملية انضمام اللاعب الثاني
                    },
                    child: const Text('انضم'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            // عرض معلومات إضافية للجلسة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('عدد الأسئلة: ${session.questionCount}'),
                Text('السؤال الحالي: ${session.currentQuestionNumber}'),
              ],
            ),
            const SizedBox(height: 8),
            // حالة الدور الحالي
            if (session.currentTurnPlayerId != null)
              Text(
                'الدور الحالي: ${session.currentTurnPlayerId}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
