import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';
import 'dashboard_tab_controller.dart';

class ProfileTabController extends GetxController {
  final displayNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final strg = Get.find<GetStorage>();
  final _userProvider = UserProvider();
  final dashboardController = Get.find<DashboardTabController>();
  late final StreamSubscription<AuthState> _authStateSub;

  bool _redirecting = false;

  Rx<UserModel> userData = UserModel(
    Id: '',
    DisplayName: '',
    Email: '',
  ).obs;

  RxBool isEdited = false.obs;
  RxBool isLoading = false.obs;

  Future<void> logout() async {
    strg.remove(SESSION_KEY);
    await supabaseClient.auth.signOut();
  }

  Future _getUserProfile() async {
    if (supabaseClient.auth.currentSession == null ||
        supabaseClient.auth.currentUser == null) {
      return await logout();
    }

    final userFromRepo = await _userProvider.getUserProfile();
    userData.value = userFromRepo;

    displayNameController.text = userData.value.DisplayName;
  }

  Future updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading.value = true;

      final response = await supabaseClient
          .from('Users')
          .update({
            'DisplayName': displayNameController.text,
          })
          .eq('Id', userData.value.Id)
          .select();

      final updatedUser = UserModel(
        Id: response[0]['Id'],
        DisplayName: response[0]['DisplayName'],
        Email: response[0]['Email'],
        ProfilePicUrl: response[0]['ProfilePictureURL'],
      );

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'Profile successfully updated!');

      isEdited.value = false;

      // refresh data on dashboard
      dashboardController.changeUserProfile(updatedUser);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future updateProfilePicture() async {
    final imgPicker = ImagePicker();
    final imgFile = await imgPicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      maxWidth: 300,
    );

    if (imgFile == null) return;

    isLoading.value = true;

    try {
      final bytes = await imgFile.readAsBytes();
      final fileExt = imgFile.path.split('.').last;
      final newFileName = 'PP-${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = newFileName; // change path if necessary

      await supabaseClient.storage
          .from('avatars')
          .uploadBinary(filePath, bytes);

      if (userData.value.ProfilePicUrl != null &&
          userData.value.ProfilePicUrl != '') {
        // delete old image storage before changing the path
        await supabaseClient.storage
            .from('avatars')
            .remove([userData.value.ProfilePicUrl!]);
      }

      final imgFinalPath =
          supabaseClient.storage.from('avatars').getPublicUrl(filePath);
      await supabaseClient.from('Users').upsert({
        'Id': userData.value.Id,
        'DisplayName': displayNameController.text,
        'Email': userData.value.Email,
        'ProfilePictureURL': imgFinalPath,
      });

      final newUserData = UserModel(
        Id: userData.value.Id,
        DisplayName: userData.value.DisplayName,
        Email: userData.value.Email,
        ProfilePicUrl: imgFinalPath,
      );

      userData.value = newUserData;
      dashboardController.changeUserProfile(newUserData);

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'Profile picture successfully changed!');
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setProfileStateAsEdited() {
    isEdited.value = true;
  }

  @override
  void onReady() async {
    super.onReady();
    await _getUserProfile();
  }

  @override
  void onInit() {
    super.onInit();
    _authStateSub = supabaseClient.auth.onAuthStateChange.listen((response) {
      if (_redirecting) return;
      final authEvent = response.event;
      if (authEvent == AuthChangeEvent.signedOut) {
        _redirecting = true;
        Get.offAllNamed(Routes.SPLASH);
      }
    });
  }

  @override
  void onClose() {
    _authStateSub.cancel();
    displayNameController.dispose();
    super.onClose();
  }
}
