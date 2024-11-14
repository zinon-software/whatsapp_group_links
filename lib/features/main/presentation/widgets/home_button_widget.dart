import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/color_manager.dart';

class HomeButtonWidget extends StatelessWidget {
  const HomeButtonWidget({
    super.key,
    required this.onTap,
    required this.logo,
    required this.icon,
    required this.title,
  });
  final VoidCallback onTap;
  final String logo;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: ColorsManager.card,
          borderRadius: BorderRadius.circular(8),
          // shape: BoxShape.rectangle,
          // boxShadow: [
          //   BoxShadow(
          //     color: ColorsManager.aed5e5.withOpacity(0.5),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              logo,
              height: 90,
              width: 90,
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.black),
            ),
            Spacer(),
            Container(
              height: 70,
              width: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
