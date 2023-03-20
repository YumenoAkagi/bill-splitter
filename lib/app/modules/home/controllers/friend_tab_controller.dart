import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import '../../../utils/validations_helper.dart';

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
      });
      response.forEach((element) {
        Map decoded = Map.from(element);
        decoded.values.toList().forEach((element) {
          friendList.add(
            UserModel(
              Id: element['Id'],
              DisplayName: element['DisplayName'],
              Email: element['Email'],
              ProfilePicUrl: element['ProfilePictureUrl'],
            ),
          );
        });
      });
      update();
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
