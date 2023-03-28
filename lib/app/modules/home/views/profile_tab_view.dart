import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../controllers/profile_tab_controller.dart';

class ProfileTabView extends StatelessWidget {
  ProfileTabView({super.key});

  final controller = Get.put<ProfileTabController>(ProfileTabController());

  @override
  Widget build(BuildContext context) {
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
              children: [
                Obx(
                  () => CircularProfileAvatar(
                    controller.userData.value.ProfilePicUrl ?? '',
                    radius: 48 * GOLDEN_RATIO,
                    cacheImage: true,
                    backgroundColor: getColorFromHex(COLOR_2),
                    initialsText: Text(
                      controller.userData.value.DisplayName[0],
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
                      Entypo.camera,
                      size: 10 * GOLDEN_RATIO,
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
                const SizedBox(
                  height: 35 * GOLDEN_RATIO,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Display Name',
                    style: Get.textTheme.labelMedium,
                  ),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: Get.textTheme.labelMedium,
                  ),
                ),
                const SizedBox(
                  height: 5 * GOLDEN_RATIO,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Text(
                      controller.userData.value.Email,
                      style: Get.textTheme.titleSmall,
                    ),
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
                              ? const Icon(Entypo.floppy)
                              : const SizedBox(
                                  width: 10 * GOLDEN_RATIO,
                                  height: 10 * GOLDEN_RATIO,
                                  child: CircularProgressIndicator(),
                                ),
                          label: (controller.isLoading.isFalse)
                              ? const Text('Save Changes')
                              : const Text('Saving Changes...'),
                        )
                      : FilledButton.icon(
                          onPressed: null,
                          icon: const Icon(Entypo.floppy),
                          label: const Text('Save Changes'),
                        ),
                ),
                const SizedBox(
                  height: 40 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Entypo.lock),
                  label: const Text('Change Password'),
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await controller.logout();
                  },
                  icon: const Icon(Entypo.logout),
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
