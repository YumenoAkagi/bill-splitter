import '../../../utils/validations_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';

class DashboardTabController extends GetxController {
  final _supabaseClient = Get.find<SupabaseClient>();
  final strg = Get.find<GetStorage>();
  Rx<UserModel> userData = UserModel(
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
      final userDataFromResponse = UserModel(
        Id: response['Id'],
        DisplayName: response['DisplayName'],
        Email: response['Email'],
        ProfilePicUrl: response['ProfilePictureURL'],
      );

      userData.value = userDataFromResponse;
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
