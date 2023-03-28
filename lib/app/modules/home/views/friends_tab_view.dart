import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../controllers/friend_tab_controller.dart';

class FriendsTabView extends StatelessWidget {
  FriendsTabView({super.key});
  final controller = Get.put<FriendTabController>(FriendTabController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V),
        child: GetBuilder<FriendTabController>(
          builder: (ftc) => ftc.friendList.isEmpty
              ? const Center(
                  child: Text('No Data'),
                )
              : ListView.builder(
                  itemCount: ftc.friendList.length,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * GOLDEN_RATIO)),
                    elevation: 2,
                    child: ListTile(
                      title: Text(ftc.friendList[index].DisplayName,
                          style: Get.textTheme.titleMedium),
                      subtitle: Text(
                        ftc.friendList[index].Email,
                        style: Get.textTheme.titleSmall,
                      ),
                      leading: CircularProfileAvatar(
                        ftc.friendList[index].ProfilePicUrl ?? '',
                        cacheImage: true,
                        backgroundColor: getColorFromHex(COLOR_2),
                        initialsText: Text(
                          ftc.friendList[index].DisplayName[0],
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        imageFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
