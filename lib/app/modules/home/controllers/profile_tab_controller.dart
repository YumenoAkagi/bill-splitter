import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';

class ProfileTabController extends GetxController {
  final displayNameController = TextEditingController();

  final _supabaseClient = Get.find<SupabaseClient>();
  final strg = Get.find<GetStorage>();
  final Rx<UserModel> userData = UserModel(
    Id: '',
    DisplayName: '',
    Email: '',
  ).obs;

  Future<void> logout() async {
    strg.remove(SESSION_KEY);
    await _supabaseClient.auth.signOut();

    // navigate back to splash
    Get.offAllNamed(Routes.SPLASH);
  }

  Future getUserProfile() async {
    try {
      if (_supabaseClient.auth.currentSession == null ||
          _supabaseClient.auth.currentUser == null) {
        return await logout();
      }

      // ensure user is logged in when retriving profile
      final response = await _supabaseClient.from('Users').select().match({
        'Id': _supabaseClient.auth.currentUser!.id,
      }).maybeSingle() as Map;

      // insert user profile
      userData.value.Id = response['Id'];
      userData.value.Email = response['Email'];
      userData.value.DisplayName = response['DisplayName'];
      userData.value.ProfilePicUrl = response['ProfilePictureUrl'];

      // insert textformfield
      displayNameController.text = userData.value.DisplayName;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await getUserProfile();
  }
}
