import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

abstract class UsersDatasources {
  Future<UserModel> fetchUser(String id);
  Future<String> createUser(UserModel request);
  Future<String> updateUser(UserModel request);

  Future<String> updatePermission(
    String userId,
    String feild,
    bool newStatus,
  );
}

class UsersDatasourcesImpl implements UsersDatasources {
  final CollectionReference users;

  UsersDatasourcesImpl(this.users);

  @override
  Future<UserModel> fetchUser(String id) async {
    try {
      DocumentSnapshot snapshot = await users.doc(id).get();

      if (!snapshot.exists) {
        return throw Exception('User not found');
      }

      final user = UserModel.fromJson(
        snapshot.data() as Map<String, dynamic>,
      );
      
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
}
