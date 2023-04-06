import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
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
        child: RefreshIndicator(
          onRefresh: controller.getFriendList,
          child: GetBuilder<FriendTabController>(
            builder: (ftc) => ftc.isFetching
                ? showFetchingScreen()
                : ftc.friendList.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: Get.height * 0.5 * GOLDEN_RATIO,
                          child: const Center(
                            child: Text('No data'),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: ftc.friendList.length,
                        itemBuilder: (context, index) => Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) async {
                            await ftc.deleteFriend(ftc.friendList[index]);
                          },
                          background: Container(
                            padding:
                                const EdgeInsets.only(right: 10 * GOLDEN_RATIO),
                            color: Colors.red.shade700,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Entypo.trash,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          confirmDismiss: (_) async {
                            bool confirmDelete = false;
                            await showConfirmDialog(context,
                                'Delete ${ftc.friendList[index].displayName}?\nThis action cannot be undone.',
                                buttonColor: Colors.red.shade700,
                                negativeText: 'Cancel',
                                positiveText: 'Delete', onAccept: () {
                              confirmDelete = true;
                            });
                            return confirmDelete;
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8 * GOLDEN_RATIO)),
                            elevation: 2,
                            child: ListTile(
                              title: Text(ftc.friendList[index].displayName,
                                  style: Get.textTheme.labelMedium),
                              subtitle: Text(
                                ftc.friendList[index].email,
                                style: Get.textTheme.titleSmall,
                              ),
                              leading: CircularProfileAvatar(
                                ftc.friendList[index].profilePicUrl ?? '',
                                radius: 15 * GOLDEN_RATIO,
                                cacheImage: true,
                                backgroundColor: getColorFromHex(COLOR_1),
                                initialsText: Text(
                                  ftc.friendList[index].displayName[0],
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
        ),
      ),
    );
  }
}
