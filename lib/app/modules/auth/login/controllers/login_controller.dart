import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSub;

  bool _redirecting = false;
  RxBool isLoading = false.obs;

  Future loginWithEmailPassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = !isLoading.value;

    final strg = Get.find<GetStorage>();

    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.session?.user != null) {
        await OneSignal.shared.setExternalUserId(response.session!.user.id);
      }

      await strg.write(SESSION_KEY, response.session?.persistSessionString);
      Get.offAllNamed(Routes.HOME);
    } on AuthException catch (e) {
      showErrorSnackbar(e.message);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _authStateSub = supabaseClient.auth.onAuthStateChange.listen((response) {
      if (_redirecting) return;
      final authEvent = response.event;
      if (authEvent == AuthChangeEvent.passwordRecovery) {
        _redirecting = true;
        Get.offAllNamed(Routes.PASSWORD_RECOVERY);
      }
    });
  }

  @override
  void onClose() {
    _authStateSub.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
