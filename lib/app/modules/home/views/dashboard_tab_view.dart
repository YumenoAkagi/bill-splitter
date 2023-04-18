import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import '../../../utils/functions_helper.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/icon_button_with_text.dart';
import '../controllers/dashboard_tab_controller.dart';
import '../controllers/home_controller.dart';

class DashboardTabView extends StatelessWidget {
  const DashboardTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardTabController());
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
                        'Hi, ${dashboardController.userData.value.displayName}',
                        style: Get.textTheme.titleLarge?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3 * GOLDEN_RATIO,
                    ),
                    Obx(
                      () => Text(
                        dashboardController.userData.value.email,
                        style: Get.textTheme.titleSmall?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => dashboardController
                          .userData.value.displayName.isEmptyOrNull
                      ? const SizedBox()
                      : CircularProfileAvatar(
                          dashboardController.userData.value.profilePicUrl ??
                              '',
                          radius: 15 * GOLDEN_RATIO,
                          onTap: () => homeController.switchTab(3),
                          cacheImage: true,
                          backgroundColor: getColorFromHex(COLOR_1),
                          initialsText: Text(
                            dashboardController.userData.value.displayName[0],
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
                    iconData: FontAwesome.history,
                    description: 'View History',
                    onTap: () {
                      Get.toNamed(Routes.HISTORYTRX);
                    },
                  ),
                  IconButtonWithText(
                    iconData: FontAwesome.help_circled,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Recent Transactions',
                    style: Get.textTheme.labelMedium,
                  ),
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
              child: GetBuilder<DashboardTabController>(
                id: dashboardController.recentTrxId,
                builder: (dtc) => dtc.isFetching.isTrue
                    ? showFetchingScreen()
                    : dtc.recentTrx.isEmpty
                        ? Column(
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
                          )
                        : ListView.builder(
                            itemCount: dtc.recentTrx.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () =>
                                  dtc.viewTrxDetail(dtc.recentTrx[index].id),
                              borderRadius:
                                  BorderRadius.circular(8 * GOLDEN_RATIO),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8 * GOLDEN_RATIO),
                                ),
                                elevation: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(
                                    5 * GOLDEN_RATIO,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        dtc.recentTrx[index].name,
                                        style: Get.textTheme.labelMedium
                                            ?.copyWith(
                                                fontSize: 11 * GOLDEN_RATIO),
                                      ),
                                      Text(
                                        dtc.recentTrx[index].date,
                                        style: Get.textTheme.labelSmall,
                                      ),
                                      const SizedBox(
                                        height: 8 * GOLDEN_RATIO,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 20 * GOLDEN_RATIO,
                                              width: Get.width,
                                              child: WidgetStack(
                                                positions: RestrictedPositions(
                                                  align: StackAlign.left,
                                                  maxCoverage:
                                                      -0.1 * GOLDEN_RATIO,
                                                  minCoverage:
                                                      0.2 * GOLDEN_RATIO,
                                                ),
                                                stackedWidgets: [
                                                  for (var i = 0;
                                                      i <
                                                          dtc
                                                              .recentTrx[index]
                                                              .membersList
                                                              .length;
                                                      i++)
                                                    CircularProfileAvatar(
                                                      dtc
                                                              .recentTrx[index]
                                                              .membersList[i]
                                                              .profilePicUrl ??
                                                          '',
                                                      radius: 20 * GOLDEN_RATIO,
                                                      cacheImage: true,
                                                      backgroundColor:
                                                          getColorFromHex(
                                                              COLOR_1),
                                                      initialsText: Text(
                                                        dtc
                                                            .recentTrx[index]
                                                            .membersList[i]
                                                            .displayName[0],
                                                        style: Get.textTheme
                                                            .titleLarge
                                                            ?.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      imageFit: BoxFit.cover,
                                                    ),
                                                ],
                                                buildInfoWidget: (surplus) =>
                                                    CircularProfileAvatar(
                                                  '',
                                                  radius: 20 * GOLDEN_RATIO,
                                                  backgroundColor:
                                                      getColorFromHex(COLOR_1),
                                                  initialsText: Text(
                                                    '+$surplus',
                                                    style: Get
                                                        .textTheme.titleLarge
                                                        ?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Total',
                                                style: Get.textTheme.labelMedium
                                                    ?.copyWith(
                                                  fontSize: 7 * GOLDEN_RATIO,
                                                ),
                                              ),
                                              Text(
                                                moneyFormatter.format(dtc
                                                    .recentTrx[index]
                                                    .grandTotal),
                                                style: Get.textTheme.labelSmall
                                                    ?.copyWith(
                                                  fontSize: 9 * GOLDEN_RATIO,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
