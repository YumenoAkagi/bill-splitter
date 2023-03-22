import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/validations_helper.dart';

class FriendProvider {
  final _supabaseClient = Get.find<SupabaseClient>();

  Future getFriendList() async {
    List<UserModel> friendList = [];
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
          friendList.add(
            UserModel(
              Id: element['Id'],
              DisplayName: element['DisplayName'],
              Email: element['Email'],
              ProfilePicUrl: element['ProfilePictureURL'],
            ),
          );
        });
      });
      return friendList;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getRequestFriendList() async {
    List<UserModel> requestfriendList = [];
  }

  Future getPendingFriendList() async {
    List<UserModel> pendingfriendList = [];
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
          pendingfriendList.add(
            UserModel(
              Id: element['Id'],
              DisplayName: element['DisplayName'],
              Email: element['Email'],
              ProfilePicUrl: element['ProfilePictureURL'],
            ),
          );
        });
      });
      return pendingfriendList;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future addFriend(String email) async {
    try {
      final response = await _supabaseClient
          .from('Users')
          .select()
          .match({'Email': email}).maybeSingle() as Map?;
      if (response == null) throw Exception('There Is No User With This Email');

      final checker = await _supabaseClient
          .from('UserFriendList')
          .select()
          .match({'FriendId': response['Id']}).maybeSingle() as Map?;
      if (checker != null) {
        throw Exception(
            'You Already Be Friend With ${response['DisplayName']}');
      }

      await _supabaseClient.from('UserFriendList').insert({
        'UserId': _supabaseClient.auth.currentUser!.id,
        'FriendId': response['Id'],
        'IsRequestPending': true,
      });

      Get.snackbar(
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: getColorFromHex(COLOR_3),
          colorText: Colors.white,
          'Friend Successfully Added',
          '${response['DisplayName']} Have been Added To Your Friend List!');
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

  Future deletePendingFriend(UserModel userModel) async {
    try {
      final checker =
          await _supabaseClient.from('UserFriendList').select().match({
        'UserId': _supabaseClient.auth.currentUser!.id,
        'FriendId': userModel.Id,
        'IsRequestPending': true,
      }).maybeSingle() as Map?;

      if (checker == null) {
        throw Exception('Friend Already Deleted');
      }

      await _supabaseClient.from('UserFriendList').delete().match({
        'UserId': _supabaseClient.auth.currentUser!.id,
        'FriendId': userModel.Id,
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
