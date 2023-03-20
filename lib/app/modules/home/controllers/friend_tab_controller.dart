import 'package:bill_splitter/app/models/user_model.dart';
import 'package:bill_splitter/app/utils/validations_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendTabController extends GetxController {
  final _supabaseClient = Get.find<SupabaseClient>();
  List<UserModel> friendList = [];
  final strg = Get.find<GetStorage>();
  Future getFriendList() async {
    try {
      final response = await _supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({
        'UserId': _supabaseClient.auth.currentUser!.id,
      }) as List<UserModel>;
      friendList = response;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await getFriendList();
  }
}
