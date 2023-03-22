import 'package:bill_splitter/app/models/user_model.dart';
import 'package:bill_splitter/app/utils/validations_helper.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageFriendController extends GetxController {
  final _supabaseClient = Get.find<SupabaseClient>();
  List<UserModel> friendList = [];
  Future addFriend() async {}
  Future getRequestFriendList() async {
    try {
      final Response = await _supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({'IsRequestPedning': true});
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getPendingFriendList() async {}

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await getRequestFriendList();
  }
}
