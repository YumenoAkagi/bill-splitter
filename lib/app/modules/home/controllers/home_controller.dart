import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

import '../../../providers/friend_provider.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/bs_add_transaction/views/add_transaction_bs_view.dart';
import '../views/dashboard_tab_view.dart';
import '../views/friends_tab_view.dart';
import '../views/profile_tab_view.dart';
import '../views/transactions_tab_view.dart';

class HomeController extends GetxController {
  final friendProvider = FriendProvider();
  final strg = Get.find<GetStorage>();
  RxInt requestCount = 0.obs;
  RxBool isDarkMode = false.obs;

  final List<BottomBarItem> bottomNavbarItemsLight = [
    BottomBarItem(
      icon: const Icon(Entypo.home),
      selectedIcon: const Icon(Entypo.home),
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
      icon: const Icon(Entypo.doc_text_inv),
      selectedIcon: const Icon(Entypo.doc_text_inv),
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
      icon: const Icon(Entypo.users),
      selectedIcon: const Icon(Entypo.users),
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
      icon: const Icon(Entypo.user),
      selectedIcon: const Icon(Entypo.user),
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
      icon: const Icon(Entypo.home),
      selectedIcon: const Icon(Entypo.home),
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
      icon: const Icon(Entypo.doc_text_inv),
      selectedIcon: const Icon(Entypo.doc_text_inv),
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
      icon: const Icon(Entypo.users),
      selectedIcon: const Icon(Entypo.users),
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
      icon: const Icon(Entypo.user),
      selectedIcon: const Icon(Entypo.user),
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

  void switchTheme() async {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await strg.write(THEME_KEY, Get.isDarkMode ? 'Light' : 'Dark');
    isDarkMode.value = !isDarkMode.value;
  }

  @override
  void onReady() async {
    super.onReady();
    requestCount.value = await friendProvider.getRequestCount() ?? 0;
    isDarkMode.value = Get.isDarkMode ? true : false;
  }

  void openAddNewTrxBottomSheet() async {
    if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) return;
    await Get.bottomSheet(
      const AddTransactionBottomSheet(),
    );
  }
}
