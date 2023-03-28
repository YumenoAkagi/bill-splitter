import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_constants.dart';

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText({
    super.key,
    required this.iconData,
    required this.description,
    required this.onTap,
    this.width = 75,
    this.height = 75,
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
          children: [
            badgeCount > 0
                ? Badge.count(
                    count: badgeCount,
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
              height: 2 * GOLDEN_RATIO,
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
