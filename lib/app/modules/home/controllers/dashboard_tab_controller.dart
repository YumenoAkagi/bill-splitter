import '../../../utils/validations_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';

class DashboardTabController extends GetxController {
  final _supabaseClient = Get.find<SupabaseClient>();
  final strg = Get.find<GetStorage>();
  final userData = UserModel(
    Id: '',
    DisplayName: '',
    Email: '',
  ).obs;

  Future getUserProfile() async {
    try {
      // ensure user is logged in when retriving profile
      final response = await _supabaseClient.from('Users').select().match({
        'Id': _supabaseClient.auth.currentUser!.id,
      }).maybeSingle() as Map;

      // insert user profile
      userData.value.Id = response['Id'];
      userData.value.Email = response['Email'];
      userData.value.DisplayName = response['DisplayName'];
      userData.value.ProfilePicUrl = response['ProfilePictureUrl'];

      update();
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserProfile();
  }
}
