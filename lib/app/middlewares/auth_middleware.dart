import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final _supabaseClient = Get.find<SupabaseClient>();
  @override
  RouteSettings? redirect(String? route) {
    return _supabaseClient.auth.currentUser != null
        ? null
        : const RouteSettings(name: Routes.SPLASH);
  }
}
