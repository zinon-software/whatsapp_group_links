import 'package:linkati/core/storage/storage_repository.dart';

import '../../../../config/app_hive_config.dart';
import '../models/slideshow_model.dart';

abstract class MainLocalDatasources {
  void saveSlideshows(List<SlideshowModel> slideshow);
  List<SlideshowModel> getSlideshows();
}

class MainLocalDatasourcesImpl implements MainLocalDatasources {
  final StorageRepository repository;

  MainLocalDatasourcesImpl({required this.repository});

  @override
  void saveSlideshows(List<SlideshowModel> slideshow) {
    try {
      repository.setData(key: AppHiveConfig.instance.keySlideshows, value: slideshow);
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<SlideshowModel> getSlideshows() {
    try {
      return repository.getData(key: AppHiveConfig.instance.keySlideshows); 
    } catch (e) {
      rethrow;
    }
  }
}
