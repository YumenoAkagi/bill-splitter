import 'package:avatars/avatars.dart';
import 'package:bill_splitter/app/modules/manage_friend/controllers/manage_friend_controller.dart';
import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:bill_splitter/app/widgets/friendBottomSheet/views/friend_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ManageFriendView extends GetView<ManageFriendController> {
  const ManageFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Friend'),
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: getColorFromHex(COLOR_5),
              unselectedLabelColor: getColorFromHex(COLOR_1),
              indicator: BoxDecoration(color: getColorFromHex(COLOR_1)),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Request',
                )
              ]),
        ),
        body: GetBuilder<ManageFriendController>(
          builder: (mtc) => TabBarView(children: [
            SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: SAFEAREA_CONTAINER_MARGIN_H,
                    vertical: SAFEAREA_CONTAINER_MARGIN_V),
                child: mtc.pendingFriendList.isEmpty
                    ? const Center(
                        child: Text('No Pending Friend Request'),
                      )
                    : ListView.builder(
                        itemCount: mtc.pendingFriendList.length,
                        itemBuilder: (context, index) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8 * GOLDEN_RATIO)),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              mtc.pendingFriendList[index].DisplayName,
                              style: Get.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              mtc.pendingFriendList[index].Email,
                              style: Get.textTheme.bodySmall,
                            ),
                            leading: Avatar(
                              shape: AvatarShape.circle(13 * GOLDEN_RATIO),
                              name: mtc.pendingFriendList[index].DisplayName,
                              sources: [
                                NetworkSource(mtc.pendingFriendList[index]
                                        .ProfilePicUrl ??
                                    '')
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Entypo.trash),
                              onPressed: () {
                                mtc.deletePendingRequest(
                                    mtc.pendingFriendList[index]);
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            SafeArea(
                child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: SAFEAREA_CONTAINER_MARGIN_H,
                  vertical: SAFEAREA_CONTAINER_MARGIN_V),
              child: mtc.requestFriendList.isEmpty
                  ? const Center(
                      child: Text('No Friend Request'),
                    )
                  : ListView.builder(
                      itemCount: mtc.requestFriendList.length,
                      itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8 * GOLDEN_RATIO)),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            mtc.requestFriendList[index].DisplayName,
                            style: Get.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            mtc.requestFriendList[index].Email,
                            style: Get.textTheme.bodySmall,
                          ),
                          leading: Avatar(
                            shape: AvatarShape.circle(13 * GOLDEN_RATIO),
                            name: mtc.requestFriendList[index].DisplayName,
                            sources: [
                              NetworkSource(
                                  mtc.requestFriendList[index].ProfilePicUrl ??
                                      '')
                            ],
                          ),
                        ),
                      ),
                    ),
            )),
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.symmetric(
              vertical: SAFEAREA_CONTAINER_MARGIN_V,
              horizontal: SAFEAREA_CONTAINER_MARGIN_H),
          child: FilledButton(
              onPressed: () {
                Get.bottomSheet(FriendBottomSheetView());
              },
              child: const Text('Add Friend')),
        ),
      ),
    );
  }
}
