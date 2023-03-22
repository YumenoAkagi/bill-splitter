import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
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
    final HomeController homeController = Get.find();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SAFEAREA_CONTAINER_MARGIN_H,
          vertical: SAFEAREA_CONTAINER_MARGIN_V,
        ),
        child: SingleChildScrollView(
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
                    () => Avatar(
                      onTap: () => homeController.switchTab(3),
                      useCache: true,
                      shape: AvatarShape.circle(15 * GOLDEN_RATIO),
                      placeholderColors: [
                        getColorFromHex(COLOR_1),
                      ],
                      backgroundColor: getColorFromHex(COLOR_2),
                      textStyle: Get.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                      name: dashboardController.userData.value.DisplayName,
                      sources:
                          (dashboardController.userData.value.ProfilePicUrl !=
                                      null &&
                                  dashboardController
                                          .userData.value.ProfilePicUrl !=
                                      '')
                              ? [
                                  NetworkSource(dashboardController
                                      .userData.value.ProfilePicUrl!),
                                ]
                              : [],
                    ),
                  ),
                ],
              ),
              const Divider(height: 15 * GOLDEN_RATIO),
              Text(
                'Your Last Active Transaction',
                style: Get.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
