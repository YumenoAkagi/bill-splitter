import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../controllers/bs_trx_members_controller.dart';

class BsTrxMembersView extends StatelessWidget {
  const BsTrxMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BsTrxMembersController());
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15 * GOLDEN_RATIO),
              topRight: Radius.circular(15 * GOLDEN_RATIO),
            ),
            color: Get.isDarkMode
                ? getColorFromHex(COLOR_DARK_MAIN)
                : Colors.white,
          ),
          width: Get.width,
          height: Get.height * 0.55 * GOLDEN_RATIO,
          padding: const EdgeInsets.only(
            right: 10 * GOLDEN_RATIO,
            left: 10 * GOLDEN_RATIO,
            bottom: 20 * GOLDEN_RATIO,
            top: 5 * GOLDEN_RATIO,
          ),
          child: Column(
            children: [
              showCustomHandleBar(),
              Text(
                'Transaction Members',
                style: Get.textTheme.labelMedium?.copyWith(
                  fontSize: 12 * GOLDEN_RATIO,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<BsTrxMembersController>(
                  builder: (bstmv) => bstmv.isFetching.isTrue
                      ? showFetchingScreen()
                      : bstmv.trxMembersList.isEmpty
                          ? const Center(
                              child: Text('No Data'),
                            )
                          : ListView.builder(
                              itemCount: bstmv.trxMembersList.length,
                              itemBuilder: (context, index) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8 * GOLDEN_RATIO)),
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    (bstmv.trxMembersList[index].id ==
                                            supabaseClient.auth.currentUser!.id)
                                        ? '${bstmv.trxMembersList[index].displayName}\t(You)'
                                        : bstmv
                                            .trxMembersList[index].displayName,
                                    style: Get.textTheme.labelMedium,
                                  ),
                                  subtitle: Text(
                                    bstmv.trxMembersList[index].email,
                                    style: Get.textTheme.titleSmall,
                                  ),
                                  leading: CircularProfileAvatar(
                                    bstmv.trxMembersList[index].profilePicUrl ??
                                        '',
                                    radius: 15 * GOLDEN_RATIO,
                                    cacheImage: true,
                                    backgroundColor: getColorFromHex(COLOR_1),
                                    initialsText: Text(
                                      bstmv
                                          .trxMembersList[index].displayName[0],
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
            ],
          ),
        )
      ],
    );
  }
}
