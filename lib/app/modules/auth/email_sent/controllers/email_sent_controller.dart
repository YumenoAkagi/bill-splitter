import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';

class EmailSentController extends GetxController {
  late final StreamSubscription<AuthState> _authStateSub;

  bool _redirecting = false;

  @override
  void onInit() {
    super.onInit();
    _redirecting = false;
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
    super.onClose();
  }
}
