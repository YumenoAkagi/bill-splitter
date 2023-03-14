import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../utils/app_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => StylishBottomBar(
          hasNotch: true,
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
            iconSize: 12 * GOLDEN_RATIO,
          ),
          items: controller.bottomNavbarItems,
          currentIndex: controller.selectedTab.value,
          onTap: controller.switchTab,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: getColorFromHex(COLOR_2),
        child: const Icon(
          Entypo.plus,
          size: 18 * GOLDEN_RATIO,
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
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
