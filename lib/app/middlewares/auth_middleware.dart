import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../utils/app_constants.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return supabaseClient.auth.currentSession != null
        ? null
        : const RouteSettings(name: Routes.SPLASH);
  }
}
