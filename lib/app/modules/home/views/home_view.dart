import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StylishBottomBar(
        hasNotch: true,
        option: AnimatedBarOptions(),
        items: controller.bottomNavbarItems,
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
      body: const Center(
        child: Text('Dashboard Content'),
      ),
    );
  }
}
