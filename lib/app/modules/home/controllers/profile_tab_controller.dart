import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import 'dashboard_tab_controller.dart';

class ProfileTabController extends GetxController {
  final displayNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final strg = Get.find<GetStorage>();
  final _userProvider = UserProvider();
  final dashboardController = Get.find<DashboardTabController>();
  late final StreamSubscription<AuthState> _authStateSub;

  String recentDisplayName = '';

  bool _redirecting = false;

  Rx<UserModel> userData = UserModel(
    id: '',
    displayName: '',
    email: '',
  ).obs;

  RxBool isEdited = false.obs;
  RxBool isLoading = false.obs;

  Future<void> logout() async {
    FeatureDiscovery.clearPreferences(Get.context as BuildContext, {
      fabFeatureId,
      homeBBFeatureId,
      trxBBFeatureId,
      friendBBFeatureId,
      profileBBFeatureId,
    });
    await OneSignal.shared.removeExternalUserId();
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

    displayNameController.text = userData.value.displayName;
    recentDisplayName = userData.value.displayName;
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
          .eq('Id', userData.value.id)
          .select();

      final updatedUser = UserModel(
        id: response[0]['Id'],
        displayName: response[0]['DisplayName'],
        email: response[0]['Email'],
        profilePicUrl: response[0]['ProfilePictureURL'],
      );

      showSuccessSnackbar('Success', 'Profile successfully updated!');

      recentDisplayName = updatedUser.displayName;
      isEdited.value = false;

      // refresh data on dashboard
      dashboardController.changeUserProfile(updatedUser);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
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

      if (userData.value.profilePicUrl != null &&
          userData.value.profilePicUrl != '') {
        // delete old image storage before changing the path
        await supabaseClient.storage
            .from('avatars')
            .remove([userData.value.profilePicUrl!]);
      }

      final imgFinalPath =
          supabaseClient.storage.from('avatars').getPublicUrl(filePath);
      await supabaseClient.from('Users').upsert({
        'Id': userData.value.id,
        'DisplayName': displayNameController.text,
        'Email': userData.value.email,
        'ProfilePictureURL': imgFinalPath,
      });

      final newUserData = UserModel(
        id: userData.value.id,
        displayName: userData.value.displayName,
        email: userData.value.email,
        profilePicUrl: imgFinalPath,
      );

      userData.value = newUserData;
      dashboardController.changeUserProfile(newUserData);

      showSuccessSnackbar('Success', 'Profile picture successfully changed!');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = false;
    }
  }

  void setProfileStateAsEdited() {
    if (displayNameController.text == recentDisplayName) {
      isEdited.value = false;
    } else {
      isEdited.value = true;
    }
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
