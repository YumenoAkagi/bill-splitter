import 'package:bill_splitter/app/utils/validations_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendBottomSheetController extends GetxController {
  final friendEmailController = TextEditingController();
  final _supabaseClient = Get.find<SupabaseClient>();
  Future addFriend() async {
    try {
      await _supabaseClient
          .from('UserFriendList')
          .insert({'UserId': _supabaseClient.auth.currentUser!.id});
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
