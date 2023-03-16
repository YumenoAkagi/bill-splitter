import 'package:avatars/avatars.dart';
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Avatar(
                  useCache: true,
                  shape: AvatarShape.circle(50 * GOLDEN_RATIO),
                  placeholderColors: [
                    getColorFromHex(COLOR_1),
                  ],
                  backgroundColor: getColorFromHex(COLOR_2),
                  textStyle: Get.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 20 * GOLDEN_RATIO,
                  ),
                  name: '[display_name]',
                ),
                const SizedBox(
                  height: 15 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: () {},
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
                  decoration: const InputDecoration(
                    hintText: 'Display Name',
                  ),
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
                  child: Text(
                    '[email@email.com]',
                    style: Get.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Entypo.floppy),
                  label: const Text('Save Changes'),
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
