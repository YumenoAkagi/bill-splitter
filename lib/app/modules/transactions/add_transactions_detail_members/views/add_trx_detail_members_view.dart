import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../controllers/add_trx_detail_members_controller.dart';

class AddTrxDetailMembersView extends GetView<AddTrxDetailMembersController> {
  const AddTrxDetailMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.trxHeader.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: controller.searchBarOpened.isTrue
                          ? TextFormField(
                              controller: controller.searchController,
                              onChanged: controller.isFetching.isTrue ||
                                      controller.isLoading.isTrue
                                  ? null
                                  : (_) => controller.searchFriend(),
                              decoration: const InputDecoration(
                                hintText: 'Search by display name',
                              ),
                            )
                          : Text(
                              'Select members',
                              style: Get.textTheme.labelMedium,
                            ),
                    ),
                    Row(
                      children: [
                        controller.searchBarOpened.isTrue &&
                                controller.isLoading.isFalse
                            ? IconButton(
                                onPressed: controller.isFetching.isTrue ||
                                        controller.isLoading.isTrue
                                    ? null
                                    : controller.clearSearchFilter,
                                icon: const Icon(
                                  FontAwesome.cancel,
                                  size: 15 * GOLDEN_RATIO,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(
                                  FontAwesome.search,
                                  size: 15 * GOLDEN_RATIO,
                                ),
                                onPressed: controller.isFetching.isTrue ||
                                        controller.isLoading.isTrue
                                    ? null
                                    : () {
                                        controller.searchBarOpened.value = true;
                                      },
                              ),
                        IconButton(
                          icon: const Icon(
                            FontAwesome.arrows_cw,
                            size: 15 * GOLDEN_RATIO,
                          ),
                          onPressed: controller.isFetching.isTrue
                              ? null
                              : controller.getFriendList,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<AddTrxDetailMembersController>(
                  builder: (atdm) => atdm.isFetching.isTrue
                      ? showFetchingScreen()
                      : atdm.friendList.isEmpty
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
                              itemCount: atdm.friendList.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  controller.selectedFriend
                                          .contains(atdm.friendList[index])
                                      ? controller.selectedFriend
                                          .remove(atdm.friendList[index])
                                      : controller.selectedFriend
                                          .add(atdm.friendList[index]);
                                },
                                borderRadius:
                                    BorderRadius.circular(8 * GOLDEN_RATIO),
                                child: Obx(
                                  () => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                        atdm.friendList[index].displayName),
                                    subtitle:
                                        Text(atdm.friendList[index].email),
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: controller.selectedFriend
                                                .contains(
                                                    atdm.friendList[index]),
                                            onChanged: null),
                                        CircularProfileAvatar(
                                          atdm.friendList[index]
                                                  .profilePicUrl ??
                                              '',
                                          radius: 15 * GOLDEN_RATIO,
                                          cacheImage: true,
                                          backgroundColor:
                                              getColorFromHex(COLOR_1),
                                          initialsText: Text(
                                            atdm.friendList[index]
                                                .displayName[0],
                                            style: Get.textTheme.titleLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          imageFit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Obx(() => FilledButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.finalizeMember
                        : null,
                    child: const Text('Finalize Members'),
                  )),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
