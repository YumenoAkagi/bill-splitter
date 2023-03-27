import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';

class SplashController extends GetxController {
  Future<AuthResponse> recoverUserSession(String session) async {
    return await supabaseClient.auth.recoverSession(session);
  }

  Future checkSession() async {
    try {
      await GetStorage.init();
      final strg = Get.find<GetStorage>();
      final session = strg.read(SESSION_KEY);

      if (session == null) {
        Get.offNamed(Routes.WALKTHROUGH);
      } else {
        final response = await recoverUserSession(session);
        await strg.write(SESSION_KEY, response.session!.persistSessionString);
        Get.offNamed(Routes.HOME);
      }
    } on AuthException catch (_) {
      // get back to login page when refresh token is expired
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Session Expired');
      Get.offNamed(Routes.LOGIN);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await checkSession();
  }
}
