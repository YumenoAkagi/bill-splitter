import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/validations_helper.dart';

class FriendProvider {
  final _supabaseClient = Get.find<SupabaseClient>();
  List<UserModel> _friendList = [];
  List<UserModel> _RequestfriendList = [];
  Future getFriendList() async {
    try {
      final response = await _supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({
        'UserId': _supabaseClient.auth.currentUser!.id,
        'IsRequestPending': false,
      });
      response.forEach((element) {
        Map decoded = Map.from(element);
        decoded.values.toList().forEach((element) {
          _friendList.add(
            UserModel(
              Id: element['Id'],
              DisplayName: element['DisplayName'],
              Email: element['Email'],
              ProfilePicUrl: element['ProfilePictureURL'],
            ),
          );
        });
      });
      return _friendList;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getRequestFriendList() async {
    try {
      final response = await _supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({
        'IsRequestPending': true,
        'UserId': _supabaseClient.auth.currentUser!.id
      });
      response.forEach((element) {
        Map decoded = Map.from(element);
        decoded.values.toList().forEach((element) {
          _RequestfriendList.add(
            UserModel(
              Id: element['Id'],
              DisplayName: element['DisplayName'],
              Email: element['Email'],
              ProfilePicUrl: element['ProfilePictureURL'],
            ),
          );
        });
      });
      return _RequestfriendList;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getPendingFriendList() async {}

  Future addFriend(String email) async {
    try {
      final Response = await _supabaseClient
          .from('Users')
          .select()
          .match({'Email': email}).maybeSingle() as Map;
      if (Response.isEmpty) return;

      await _supabaseClient.from('UserFriendList').insert({
        'UserId': _supabaseClient.auth.currentUser!.id,
        'FriendId': Response['Id'],
        'IsRequestPending': true,
      });
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: getColorFromHex(COLOR_5),
          colorText: Colors.white,
          unexpectedErrorText,
          e.toString());
    }
  }
}
