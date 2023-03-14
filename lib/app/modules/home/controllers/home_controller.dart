import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

class HomeController extends GetxController {
  final List<BottomBarItem> bottomNavbarItems = [
    BottomBarItem(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home_filled),
      unSelectedColor: getColorFromHex(COLOR_1),
      selectedColor: getColorFromHex(COLOR_2),
      title: const Text('Home'),
    ),
    BottomBarItem(
      icon: const Icon(Icons.receipt_outlined),
      selectedIcon: const Icon(Icons.receipt),
      unSelectedColor: getColorFromHex(COLOR_1),
      selectedColor: getColorFromHex(COLOR_2),
      title: const Text('Transactions'),
    ),
    BottomBarItem(
      icon: const Icon(Icons.people_outline),
      selectedIcon: const Icon(Icons.people),
      unSelectedColor: getColorFromHex(COLOR_1),
      selectedColor: getColorFromHex(COLOR_2),
      title: const Text('Friends'),
    ),
    BottomBarItem(
      icon: const Icon(Icons.person_2_outlined),
      selectedIcon: const Icon(Icons.person_2),
      unSelectedColor: getColorFromHex(COLOR_1),
      selectedColor: getColorFromHex(COLOR_2),
      title: const Text('Profile'),
    ),
  ];
}
