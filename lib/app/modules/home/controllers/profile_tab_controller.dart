import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';
import 'dashboard_tab_controller.dart';

class ProfileTabController extends GetxController {
  final displayNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _supabaseClient = Get.find<SupabaseClient>();
  final strg = Get.find<GetStorage>();
  final Rx<UserModel> userData = UserModel(
    Id: '',
    DisplayName: '',
    Email: '',
  ).obs;
  final dashboardController = Get.find<DashboardTabController>();

  RxBool isEdited = false.obs;
  RxBool isLoading = false.obs;

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

  Future updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading.value = true;

      await _supabaseClient.from('Users').upsert({
        'Id': userData.value.Id,
        'DisplayName': displayNameController.text,
        'Email': userData.value.Email
      });

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'Profile successfully updated!');

      isEdited.value = false;

      // refresh data on dashboard
      dashboardController.getUserProfile();
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future updateProfilePicture() async {
    try {} catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  void setProfileStateAsEdited() {
    isEdited.value = true;
  }

  @override
  void onReady() async {
    super.onReady();
    await getUserProfile();
  }
}
