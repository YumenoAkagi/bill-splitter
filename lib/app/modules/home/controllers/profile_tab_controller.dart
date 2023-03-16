import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTabController extends GetxController {
  final _supabaseClient = Get.find<SupabaseClient>();
  final strg = Get.find<GetStorage>();

  Future<void> logout() async {
    strg.remove(SESSION_KEY);
    await _supabaseClient.auth.signOut();

    // navigate back to splash
    Get.offAllNamed(Routes.SPLASH);
  }
}
