import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

abstract class UsersRemoteDatasources {
  Future<List<UserModel>> fetchUsers();
  Future<UserModel> fetchUser(String id);
  Future<String> createUser(UserModel request);
  Future<String> updateUser(UserModel request);

  Future<String> updatePermission(
    String userId,
    String feild,
    bool newStatus,
  );

  Future<UserModel> incrementScore(String uid, int score);
}

class UsersRemoteDatasourcesImpl implements UsersRemoteDatasources {
  final CollectionReference users;

  UsersRemoteDatasourcesImpl(this.users);

  @override
  Future<UserModel> fetchUser(String id) async {
    try {
      DocumentSnapshot snapshot = await users.doc(id).get();

      final UserModel user;

      if (!snapshot.exists) {
        user = UserModel.isEmpty().copyWith(id: id);
        await createUser(user);
      } else {
        user = UserModel.fromJson(
          snapshot.data() as Map<String, dynamic>,
        );
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createUser(UserModel request) async {
    try {
      await users.doc(request.id).set(request.toJson());
      return "تم تحديث حالة التصريح بنجاح";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateUser(UserModel request) async {
    try {
      await users.doc(request.id).update(request.toJson());
      return "تم تحديث حالة التصريح بنجاح";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updatePermission(
      String userId, String feild, bool newStatus) async {
    try {
      await users.doc(userId).update({
        'permissions.$feild': newStatus,
      });
      return "تم تحديث حالة التصريح بنجاح";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> incrementScore(String uid, int score) async {
    try {
      UserModel user = await fetchUser(uid);

      user = user.copyWith(score: user.score + score);

      await users.doc(uid).update(user.toJson());

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await users.get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
