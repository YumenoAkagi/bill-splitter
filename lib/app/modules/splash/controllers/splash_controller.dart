import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';

class SplashController extends GetxController {
  final strg = Get.find<GetStorage>();
  Future<AuthResponse> recoverUserSession(String session) async {
    return await supabaseClient.auth.recoverSession(session);
  }

  Future checkSession() async {
    try {
      await GetStorage.init();
      final session = strg.read(SESSION_KEY);

      if (session == null) {
        Get.offNamed(Routes.WALKTHROUGH);
      } else {
        final response = await recoverUserSession(session);
        await strg.write(SESSION_KEY, response.session!.persistSessionString);
        Future.delayed(
            const Duration(seconds: 1), () => Get.offNamed(Routes.HOME));
      }
    } on AuthException catch (_) {
      // get back to login page when refresh token is expired
      showErrorSnackbar('Session expired');
      Get.offNamed(Routes.LOGIN);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await checkSession();

    final themeMode = strg.read(THEME_KEY);
    if (themeMode == 'Dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
