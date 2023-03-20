import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

import '../../../utils/app_constants.dart';
import '../views/dashboard_tab_view.dart';
import '../views/friends_tab_view.dart';
import '../views/profile_tab_view.dart';
import '../views/transactions_tab_view.dart';

class HomeController extends GetxController {
  final List<BottomBarItem> bottomNavbarItems = [
    BottomBarItem(
      icon: const Icon(Entypo.home),
      selectedIcon: const Icon(Entypo.home),
      unSelectedColor: getColorFromHex(COLOR_3),
      selectedColor: getColorFromHex(COLOR_2),
      title: Text(
        'Home',
        style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 8 * GOLDEN_RATIO,
        ),
      ),
    ),
    BottomBarItem(
      icon: const Icon(Entypo.doc_text_inv),
      selectedIcon: const Icon(Entypo.doc_text_inv),
      unSelectedColor: getColorFromHex(COLOR_3),
      selectedColor: getColorFromHex(COLOR_2),
      title: Text(
        'Transactions',
        style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 8 * GOLDEN_RATIO,
        ),
      ),
    ),
    BottomBarItem(
      icon: const Icon(Entypo.users),
      selectedIcon: const Icon(Entypo.users),
      unSelectedColor: getColorFromHex(COLOR_3),
      selectedColor: getColorFromHex(COLOR_2),
      title: Text(
        'Friends',
        style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 8 * GOLDEN_RATIO,
        ),
      ),
    ),
    BottomBarItem(
      icon: const Icon(Entypo.user),
      selectedIcon: const Icon(Entypo.user),
      unSelectedColor: getColorFromHex(COLOR_3),
      selectedColor: getColorFromHex(COLOR_2),
      title: Text(
        'Profile',
        style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 8 * GOLDEN_RATIO,
        ),
      ),
    ),
  ];
  final pageController = PageController(
    initialPage: 0,
  );
  final tabViewsList = [
    DashboardTabView(),
    const TransactionsTabView(),
    FriendsTabView(),
    ProfileTabView(),
  ];
  final tabNames = [
    'Bill Splitter',
    'Transactions',
    'Friends',
    'Profile',
  ];

  RxInt selectedTab = 0.obs;

  void switchTab(int index) {
    selectedTab.value = index;
    pageController.jumpToPage(index);

    // DO NOT USE
    // this caused bug duplicated globalkey
    // pageController.animateToPage(
    //   index,
    //   duration: const Duration(
    //     milliseconds: 275,
    //   ),
    //   curve: Curves.easeInOut,
    // );
  }
}
