import 'package:avatars/avatars.dart';
import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/friend_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    child: ListTile(
                      title: Text(ftc.friendList[index].DisplayName,
                          style: Get.textTheme.titleMedium),
                      subtitle: Text(
                        ftc.friendList[index].Email,
                        style: Get.textTheme.titleSmall,
                      ),
                      leading: Avatar(
                        shape: AvatarShape.circle(13 * GOLDEN_RATIO),
                        name: ftc.friendList[index].DisplayName,
                        sources: [
                          NetworkSource(
                              ftc.friendList[index].ProfilePicUrl ?? '')
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
