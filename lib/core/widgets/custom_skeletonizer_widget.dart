import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/color_manager.dart';

class CustomSkeletonizerWidget extends StatelessWidget {
  const CustomSkeletonizerWidget({
    super.key,
    required this.enabled,
    required this.child,
    this.ignoreContainers = false,
  });
  final bool enabled;
  final Widget child;
  final bool ignoreContainers;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      justifyMultiLineText: true,
      ignoreContainers: ignoreContainers,
      ignorePointers: true,
      containersColor:
          ignoreContainers ? Theme.of(context).colorScheme.surface : null,
      effect: ShimmerEffect(
        baseColor: ColorsManager.fillColor.withOpacity(1),
        duration: const Duration(milliseconds: 900),
      ),
      child: child,
    );
  }
}
