import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/slideshow_model.dart';

abstract class MainRemoteDatasources {
  // slideshows
  Future<String> createSlideshow(SlideshowModel slideshow);
  Future<List<SlideshowModel>> fetchSlideshows();
  Future<String> updateSlideshow(SlideshowModel slideshow);
  Future<String> deleteSlideshow(SlideshowModel slideshow);
}

class MainRemoteDatasourcesImpl implements MainRemoteDatasources {
  final CollectionReference slideshows;

  MainRemoteDatasourcesImpl({required this.slideshows});

  @override
  Future<String> createSlideshow(SlideshowModel slideshow) async {
    try {
      final DocumentReference docRef = slideshows.doc();

      await slideshows.doc(docRef.id).set(
            slideshow.copyWith(id: docRef.id).toJson(),
          );

      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SlideshowModel>> fetchSlideshows() async {
    try {
      final QuerySnapshot querySnapshot = await slideshows.get();
      final List<SlideshowModel> slideshowsData = querySnapshot.docs
          .map((doc) =>
              SlideshowModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return slideshowsData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateSlideshow(SlideshowModel slideshow) async {
    try {
      await slideshows.doc(slideshow.id).update(slideshow.toJson());
      return 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteSlideshow(SlideshowModel slideshow) async {
    try {
      // check if the game exists
      final doc = await slideshows.doc(slideshow.id).get();
      if (!doc.exists) {
        return 'Game not found';
      }
      await doc.reference.delete();
      return 'success';
    } catch (e) {
      rethrow;
    }
  }
}
