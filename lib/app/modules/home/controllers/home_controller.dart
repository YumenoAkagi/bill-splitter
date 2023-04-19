import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

  final pageController = PageController(
    initialPage: 0,
  );
  final tabViewsList = [
    const DashboardTabView(),
    const TransactionsTabView(),
    const FriendsTabView(),
    const ProfileTabView(),
  ];
  final tabNames = [
    'Home',
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

  void recalcFriendRequest() async {
    requestCount.value = await friendProvider.getRequestCount() ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(Get.context as BuildContext, {
        fabFeatureId,
        homeBBFeatureId,
        trxBBFeatureId,
        friendBBFeatureId,
        profileBBFeatureId,
      });
    });
  }

  @override
  void onReady() async {
    super.onReady();
    recalcFriendRequest();
    isDarkMode.value = Get.isDarkMode ? true : false;
  }

  void openAddNewTrxBottomSheet() async {
    if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) return;
    await Get.bottomSheet(
      const AddTransactionBottomSheet(),
    );
  }
}
