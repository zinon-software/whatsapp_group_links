import 'package:dartz/dartz.dart';
import 'package:linkati/core/api/error_handling.dart';

import '../../../../core/network/connection_status.dart';
import '../datasources/main_datasources.dart';
import '../models/slideshow_model.dart';

abstract class MainRepository {
  Future<Either<String, List<SlideshowModel>>> fetchSlideshows();

  Future<Either<String, String>> createSlideshow(SlideshowModel slideshow);

  Future<Either<String, String>> updateSlideshow(SlideshowModel slideshow);

  Future<Either<String, String>> deleteSlideshow(SlideshowModel slideshow);
}

class MainRepositoryImpl implements MainRepository {
  final MainDatasources datasources;
  final ConnectionStatus connectionStatus;

  MainRepositoryImpl(this.datasources, this.connectionStatus);

  @override
  Future<Either<String, List<SlideshowModel>>> fetchSlideshows() async {
    if (await connectionStatus.isNotConnected) {
      return const Left("تحقق من جودة اتصالك بالانترنت");
    }

    try {
      final response = await datasources.fetchSlideshows();
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
      final response = await datasources.createSlideshow(slideshow);
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
      final response = await datasources.updateSlideshow(slideshow);
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
      final response = await datasources.deleteSlideshow(slideshow);
      return Right(response);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
