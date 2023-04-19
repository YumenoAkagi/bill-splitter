import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BottomBarItem> bottomNavbarItemsLight = [
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: homeBBFeatureId,
          tapTarget: const Icon(FontAwesome.home),
          title: Text(
            'Home (Dashboard)',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view dashboard page',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.home),
        ),
        selectedIcon: const Icon(FontAwesome.home),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: getColorFromHex(COLOR_2),
        title: Text(
          'Home',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: trxBBFeatureId,
          tapTarget: const Icon(FontAwesome.doc_text_inv),
          title: Text(
            'View Transactions',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view active transactions and history transactions',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.doc_text_inv),
        ),
        selectedIcon: const Icon(FontAwesome.doc_text_inv),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: getColorFromHex(COLOR_2),
        title: Text(
          'Transactions',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: friendBBFeatureId,
          tapTarget: const Icon(FontAwesome.users),
          title: Text(
            'View Friends',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view and manage friends list',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.users),
        ),
        selectedIcon: const Icon(FontAwesome.users),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: getColorFromHex(COLOR_2),
        title: Text(
          'Friends',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: profileBBFeatureId,
          tapTarget: const Icon(FontAwesome.user),
          title: Text(
            'View Profile',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view and manage profile, change password, and logout',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.user),
        ),
        selectedIcon: const Icon(FontAwesome.user),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: getColorFromHex(COLOR_2),
        title: Text(
          'Profile',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
          ),
        ),
      ),
    ];
    final List<BottomBarItem> bottomNavbarItemsDark = [
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: homeBBFeatureId,
          tapTarget: Icon(
            FontAwesome.home,
            color: getColorFromHex(COLOR_1),
          ),
          title: Text(
            'Home (Dashboard)',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view dashboard page',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.home),
        ),
        selectedIcon: const Icon(FontAwesome.home),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: Colors.white,
        title: Text(
          'Home',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
            color: Colors.white,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: trxBBFeatureId,
          tapTarget: Icon(
            FontAwesome.doc_text_inv,
            color: getColorFromHex(COLOR_1),
          ),
          title: Text(
            'View Transactions',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view active transactions and history transactions',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.doc_text_inv),
        ),
        selectedIcon: const Icon(FontAwesome.doc_text_inv),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: Colors.white,
        title: Text(
          'Transactions',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
            color: Colors.white,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: friendBBFeatureId,
          tapTarget: Icon(
            FontAwesome.users,
            color: getColorFromHex(COLOR_1),
          ),
          title: Text(
            'View Friends',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view and manage friends list',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.users),
        ),
        selectedIcon: const Icon(FontAwesome.users),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: Colors.white,
        title: Text(
          'Friends',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
            color: Colors.white,
          ),
        ),
      ),
      BottomBarItem(
        icon: DescribedFeatureOverlay(
          featureId: profileBBFeatureId,
          tapTarget: Icon(
            FontAwesome.user,
            color: getColorFromHex(COLOR_1),
          ),
          title: Text(
            'View Profile',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to view and manage profile, change password, and logout',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: const Icon(FontAwesome.user),
        ),
        selectedIcon: const Icon(FontAwesome.user),
        unSelectedColor: getColorFromHex(COLOR_3),
        selectedColor: Colors.white,
        title: Text(
          'Profile',
          style: Get.textTheme.labelMedium?.copyWith(
            fontSize: 8 * GOLDEN_RATIO,
            color: Colors.white,
          ),
        ),
      ),
    ];

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
                ? DescribedFeatureOverlay(
                    featureId: manageFriendFeatureId,
                    tapTarget: Icon(
                      FontAwesome5.user_friends,
                      color: Get.isDarkMode
                          ? getColorFromHex(COLOR_1)
                          : getColorFromHex(COLOR_2),
                    ),
                    title: Text(
                      'Manage Friends',
                      style: Get.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12 * GOLDEN_RATIO,
                      ),
                    ),
                    description: Text(
                      'Tap here to view and manage pending request and incoming request or add new friends',
                      style: Get.textTheme.labelSmall?.copyWith(
                          color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
                    ),
                    backgroundColor: getColorFromHex(COLOR_1),
                    child: IconButton(
                      onPressed: () {
                        Get.toNamed(Routes.MANAGE_FRIEND);
                      },
                      iconSize: 12 * GOLDEN_RATIO,
                      padding: const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                      icon: const Icon(
                        FontAwesome5.user_friends,
                      ),
                    ),
                  )
                : controller.selectedTab.value == 0
                    ? IconButton(
                        onPressed: () {
                          Get.offNamed(Routes.CONFIGS);
                        },
                        icon: const Icon(FontAwesome.cog),
                        iconSize: 12 * GOLDEN_RATIO,
                        padding: const EdgeInsets.only(right: 5 * GOLDEN_RATIO),
                      )
                    : controller.selectedTab.value == 1
                        ? DescribedFeatureOverlay(
                            featureId: historyTrxFeatureId,
                            tapTarget: Icon(
                              FontAwesome.history,
                              color: Get.isDarkMode
                                  ? getColorFromHex(COLOR_1)
                                  : getColorFromHex(COLOR_2),
                            ),
                            title: Text(
                              'View History Transactions',
                              style: Get.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 12 * GOLDEN_RATIO,
                              ),
                            ),
                            description: Text(
                              'Tap here to view completed transactions',
                              style: Get.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 9 * GOLDEN_RATIO),
                            ),
                            backgroundColor: getColorFromHex(COLOR_1),
                            child: IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.HISTORYTRX);
                              },
                              iconSize: 12 * GOLDEN_RATIO,
                              icon: const Icon(FontAwesome.history),
                              padding: const EdgeInsets.only(
                                  right: 5 * GOLDEN_RATIO),
                            ),
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
              ? bottomNavbarItemsLight
              : bottomNavbarItemsDark,
          currentIndex: controller.selectedTab.value,
          onTap: controller.switchTab,
          backgroundColor: controller.isDarkMode.isTrue
              ? getColorFromHex(COLOR_DARK_MAIN)
              : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => DescribedFeatureOverlay(
          featureId: fabFeatureId,
          tapTarget: FloatingActionButton(
            onPressed: null,
            backgroundColor: controller.isDarkMode.isTrue
                ? getColorFromHex(COLOR_1)
                : getColorFromHex(COLOR_2),
            child: Icon(
              FontAwesome.plus,
              color: controller.isDarkMode.isTrue ? Colors.white : null,
              size: 15 * GOLDEN_RATIO,
            ),
          ),
          title: Text(
            'Add New Transaction',
            style: Get.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12 * GOLDEN_RATIO,
            ),
          ),
          description: Text(
            'Tap here to create new transaction',
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Colors.white, fontSize: 9 * GOLDEN_RATIO),
          ),
          backgroundColor: getColorFromHex(COLOR_1),
          child: FloatingActionButton(
            onPressed: controller.openAddNewTrxBottomSheet,
            backgroundColor: controller.isDarkMode.isTrue
                ? getColorFromHex(COLOR_1)
                : getColorFromHex(COLOR_2),
            child: Icon(
              FontAwesome.plus,
              color: controller.isDarkMode.isTrue ? Colors.white : null,
              size: 15 * GOLDEN_RATIO,
            ),
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
