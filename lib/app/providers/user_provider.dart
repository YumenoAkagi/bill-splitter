import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../utils/validations_helper.dart';

class UserProvider {
  final _supabaseClient = Get.find<SupabaseClient>();

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
      return userDataFromResponse;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
