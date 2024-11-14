import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/color_manager.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,

      maxWidthDiskCache: int.tryParse(width.toString()), // تحديد عرض الكاش
      maxHeightDiskCache: int.tryParse(height.toString()), // تحديد ارتفاع الكاش
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: Skeleton.leaf(
          enabled: true,
          child: Card(color: ColorsManager.fillColor.withOpacity(1)),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.hide_image_outlined,
          color: Theme.of(context).textTheme.displayLarge!.color,
        ),
      ),
    );
  }

  // add imageProvider to CachedNetworkImage
  CachedNetworkImageProvider get imageProvider => CachedNetworkImageProvider(
        imageUrl,
      );
}
