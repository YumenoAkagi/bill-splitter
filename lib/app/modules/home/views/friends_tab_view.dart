import 'package:bill_splitter/app/modules/home/controllers/friend_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsTabView extends StatelessWidget {
  FriendsTabView({super.key});
  final controller = Get.put<FriendTabController>(FriendTabController());
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Friends Tab View'),
    );
  }
}
