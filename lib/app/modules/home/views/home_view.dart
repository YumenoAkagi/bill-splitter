import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.tabNames[controller.selectedTab.value],
          ),
        ),
        actions: [
          Obx(
            () => controller.selectedTab.value == 2
                ? IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.MANAGE_FRIEND);
                    },
                    iconSize: 12 * GOLDEN_RATIO,
                    padding: const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                    icon: const Icon(
                      FontAwesome5.user_friends,
                    ),
                  )
                : controller.selectedTab.value == 0
                    ? IconButton(
                        onPressed: () {},
                        iconSize: 12 * GOLDEN_RATIO,
                        padding: const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                        icon: const Icon(
                          FontAwesome.bell,
                        ),
                      )
                    : controller.selectedTab.value == 1
                        ? IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.HISTORYTRX);
                            },
                            iconSize: 12 * GOLDEN_RATIO,
                            icon: const Icon(Entypo.back_in_time),
                            padding:
                                const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                          )
                        : const SizedBox(),
          ),
          Obx(
            () => controller.selectedTab.value == 0
                ? IconButton(
                    onPressed: () {
                      Get.offNamed(Routes.CONFIGS);
                    },
                    icon: const Icon(FontAwesome5.cog),
                    iconSize: 12 * GOLDEN_RATIO,
                    padding: const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => StylishBottomBar(
          hasNotch: true,
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
            iconSize: 12 * GOLDEN_RATIO,
          ),
          items: controller.isDarkMode.isFalse
              ? controller.bottomNavbarItemsLight
              : controller.bottomNavbarItemsDark,
          currentIndex: controller.selectedTab.value,
          onTap: controller.switchTab,
          backgroundColor: controller.isDarkMode.isTrue
              ? getColorFromHex(COLOR_DARK_MAIN)
              : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: controller.openAddNewTrxBottomSheet,
          backgroundColor: controller.isDarkMode.isTrue
              ? getColorFromHex(COLOR_1)
              : getColorFromHex(COLOR_2),
          child: Icon(
            Entypo.plus,
            color: controller.isDarkMode.isTrue ? Colors.white : null,
            size: 18 * GOLDEN_RATIO,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          itemCount: controller.tabViewsList.length,
          itemBuilder: (_, __) {
            return controller.tabViewsList[controller.selectedTab.value];
          },
        ),
      ),
    );
  }
}
