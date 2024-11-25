import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../config/app_hive_config.dart';
import 'slideshow_model.dart';

// list slideshows
class ListSlideshowModelAdapter extends TypeAdapter<List<SlideshowModel>> {
  @override
  final int typeId = AppHiveConfig.instance.keyListSlideshowID;

  @override
  List<SlideshowModel> read(BinaryReader reader) {
    final jsonList = reader.readList();
    return jsonList.map((json) => SlideshowModel.fromJson(json)).toList();
  }

  @override
  void write(BinaryWriter writer, List<SlideshowModel> obj) {
    writer.writeList(obj.map((e) => e.toJson()).toList());
  }
}

class SlideshowModelAdapter extends TypeAdapter<SlideshowModel> {
  @override
  final int typeId = AppHiveConfig.instance.keySlideshowID;

  @override
  SlideshowModel read(BinaryReader reader) {
    String jsonString = reader.readString();

    // Parse the JSON string to a map
    final jsonMap = json.decode(jsonString);

    // Deserialize the JSON map to SlideshowModel object
    return SlideshowModel.fromJson(jsonMap);
  }

  @override
  void write(BinaryWriter writer, SlideshowModel obj) {
    // Convert the SlideshowModel object to a JSON map
    final jsonMap = obj.toJson();

    // Encode the JSON map to a JSON string
    final jsonString = json.encode(jsonMap);

    // Write the JSON string to binary
    writer.writeString(jsonString);
  }
}
