import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:badges/badges.dart' as badges;

import '../utils/app_constants.dart';

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText({
    super.key,
    required this.iconData,
    required this.description,
    required this.onTap,
    this.width = 65,
    this.height = 65,
    this.badgeCount = 0,
  });
  final IconData iconData;
  final String description;
  final double width;
  final double height;
  final int badgeCount;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            badgeCount > 0
                ? badges.Badge(
                    badgeContent: Text(
                      badgeCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      iconData,
                      color: getColorFromHex(COLOR_5),
                    ),
                  )
                : Icon(
                    iconData,
                    color: getColorFromHex(COLOR_5),
                  ),
            const SizedBox(
              height: 3 * GOLDEN_RATIO,
            ),
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Get.textTheme.labelMedium?.copyWith(
                  color: getColorFromHex(COLOR_5),
                  overflow: TextOverflow.visible,
                  fontSize: 8 * GOLDEN_RATIO,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
