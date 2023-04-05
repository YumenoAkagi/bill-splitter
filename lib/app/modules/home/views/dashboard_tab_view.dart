import 'package:fluttericon/font_awesome5_icons.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/icon_button_with_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../controllers/dashboard_tab_controller.dart';
import '../controllers/home_controller.dart';

class DashboardTabView extends StatelessWidget {
  DashboardTabView({super.key});

  final dashboardController = Get.put(DashboardTabController());

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SAFEAREA_CONTAINER_MARGIN_H,
          vertical: SAFEAREA_CONTAINER_MARGIN_V,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        'Hi, ${dashboardController.userData.value.DisplayName}',
                        style: Get.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 3 * GOLDEN_RATIO,
                    ),
                    Obx(
                      () => Text(
                        dashboardController.userData.value.Email,
                        style: Get.textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => dashboardController
                          .userData.value.DisplayName.isEmptyOrNull
                      ? const SizedBox()
                      : CircularProfileAvatar(
                          dashboardController.userData.value.ProfilePicUrl ??
                              '',
                          radius: 15 * GOLDEN_RATIO,
                          onTap: () => homeController.switchTab(3),
                          cacheImage: true,
                          backgroundColor: getColorFromHex(COLOR_1),
                          initialsText: Text(
                            dashboardController.userData.value.DisplayName[0],
                            style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          imageFit: BoxFit.cover,
                        ),
                ),
              ],
            ),
            const Divider(height: 15 * GOLDEN_RATIO),
            const SizedBox(
              height: 3 * GOLDEN_RATIO,
            ),
            Text(
              'Quick Action',
              style: Get.textTheme.labelMedium,
            ),
            const SizedBox(
              height: 13 * GOLDEN_RATIO,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => IconButtonWithText(
                      iconData: FontAwesome5.user_friends,
                      description: 'Manage Friend',
                      badgeCount: homeController.requestCount.value,
                      onTap: () {
                        Get.toNamed(Routes.MANAGE_FRIEND);
                      },
                    ),
                  ),
                  IconButtonWithText(
                    iconData: Entypo.back_in_time,
                    description: 'View History',
                    onTap: () {
                      Get.toNamed(Routes.HISTORYTRX);
                    },
                  ),
                  IconButtonWithText(
                    iconData: Entypo.help_circled,
                    description: 'Help',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(height: 15 * GOLDEN_RATIO),
            const SizedBox(
              height: 5 * GOLDEN_RATIO,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Last Active Transactions',
                  style: Get.textTheme.labelMedium,
                ),
                TextButton(
                  onPressed: () {
                    homeController.switchTab(1);
                  },
                  child: Text(
                    'Show More',
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: getColorFromHex(COLOR_1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/undraw_Empty.png',
                    width: Get.width * 0.45 * GOLDEN_RATIO,
                  ),
                  const SizedBox(
                    height: 3 * GOLDEN_RATIO,
                  ),
                  Text(
                    "You haven't created any transactions yet.",
                    style: Get.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
