import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../controllers/profile_tab_controller.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileTabController());
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SAFEAREA_CONTAINER_MARGIN_H,
          vertical: SAFEAREA_CONTAINER_MARGIN_V,
        ),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Obx(
                      () => CircularProfileAvatar(
                        controller.userData.value.profilePicUrl ?? '',
                        radius: 48 * GOLDEN_RATIO,
                        cacheImage: true,
                        backgroundColor: getColorFromHex(COLOR_1),
                        initialsText: Text(
                          controller.userData.value.displayName.isEmptyOrNull
                              ? ''
                              : controller.userData.value.displayName[0],
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        imageFit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 15 * GOLDEN_RATIO,
                    ),
                    Obx(
                      () => FilledButton.icon(
                        onPressed: controller.isLoading.isFalse
                            ? () async {
                                await controller.updateProfilePicture();
                              }
                            : null,
                        icon: const Icon(
                          FontAwesome.camera,
                          size: BUTTON_ICON_SIZE,
                        ),
                        label: const Text('Edit Photo'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(
                            70 * GOLDEN_RATIO,
                            25 * GOLDEN_RATIO,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35 * GOLDEN_RATIO,
                ),
                Text(
                  'Display Name',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                TextFormField(
                  controller: controller.displayNameController,
                  decoration: const InputDecoration(
                    hintText: 'Display Name',
                  ),
                  onChanged: (_) {
                    controller.setProfileStateAsEdited();
                  },
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                Text(
                  'Email',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 5 * GOLDEN_RATIO,
                ),
                Obx(
                  () => Text(
                    controller.userData.value.email,
                    style: Get.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Obx(
                  () => (controller.isEdited.isTrue)
                      ? FilledButton.icon(
                          onPressed: controller.isLoading.isFalse
                              ? () async {
                                  await controller.updateProfile();
                                }
                              : null,
                          icon: (controller.isLoading.isFalse)
                              ? const Icon(
                                  FontAwesome.floppy,
                                  size: BUTTON_ICON_SIZE,
                                )
                              : showCustomCircularProgressIndicator(),
                          label: (controller.isLoading.isFalse)
                              ? const Text('Save Changes')
                              : const Text('Saving Changes...'),
                        )
                      : FilledButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            FontAwesome.floppy,
                            size: BUTTON_ICON_SIZE,
                          ),
                          label: const Text('Save Changes'),
                        ),
                ),
                const SizedBox(
                  height: 40 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.CHANGE_PASSWORD);
                  },
                  icon: const Icon(
                    FontAwesome.lock,
                    size: BUTTON_ICON_SIZE,
                  ),
                  label: const Text('Change Password'),
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await showConfirmDialog(
                      context,
                      'Log out from this account?',
                      positiveText: 'Log Out',
                      negativeText: 'Cancel',
                      buttonColor: Colors.red.shade700,
                      onAccept: controller.logout,
                    );
                  },
                  icon: const Icon(
                    FontAwesome.logout,
                    size: BUTTON_ICON_SIZE,
                  ),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
