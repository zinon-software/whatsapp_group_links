import 'package:dartz/dartz.dart';
import 'package:linkati/core/api/error_handling.dart';

import '../../../../core/network/connection_status.dart';
import '../datasources/main_local_datasources.dart';
import '../datasources/main_remote_datasources.dart';
import '../models/slideshow_model.dart';

abstract class MainRepository {
  Future<Either<String, List<SlideshowModel>>> fetchSlideshows();
  Either<String, List<SlideshowModel>> getSlideshows();

  Future<Either<String, String>> createSlideshow(SlideshowModel slideshow);

  Future<Either<String, String>> updateSlideshow(SlideshowModel slideshow);

  Future<Either<String, String>> deleteSlideshow(SlideshowModel slideshow);
}

class MainRepositoryImpl implements MainRepository {
  final MainRemoteDatasources remoteDatasources;
  final MainLocalDatasources localDatasources;
  final ConnectionStatus connectionStatus;

  MainRepositoryImpl({
    required this.remoteDatasources,
    required this.localDatasources,
    required this.connectionStatus,
  });

  @override
  Future<Either<String, List<SlideshowModel>>> fetchSlideshows() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.fetchSlideshows();
      localDatasources.saveSlideshows(response);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> createSlideshow(
      SlideshowModel slideshow) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.createSlideshow(slideshow);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> updateSlideshow(
      SlideshowModel slideshow) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.updateSlideshow(slideshow);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> deleteSlideshow(
      SlideshowModel slideshow) async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await remoteDatasources.deleteSlideshow(slideshow);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
  
  @override
  Either<String, List<SlideshowModel>>  getSlideshows() {
    try {
      return Right(localDatasources.getSlideshows());
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
