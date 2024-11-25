import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../config/app_hive_config.dart';
import 'user_model.dart';


class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = AppHiveConfig.instance.keyUserID;

  @override
  UserModel read(BinaryReader reader) {
    String jsonString = reader.readString();

    // Parse the JSON string to a map
    final jsonMap = json.decode(jsonString);

    // Deserialize the JSON map to UserModel object
    return UserModel.fromJson(jsonMap);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    // Convert the UserModel object to a JSON map
    final jsonMap = obj.toJson();

    // Encode the JSON map to a JSON string
    final jsonString = json.encode(jsonMap);

    // Write the JSON string to binary
    writer.writeString(jsonString);
  }
}
