import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/validations_helper.dart';

class FriendProvider {
  Future getFriendList() async {
    List<UserModel> friendList = [];
    try {
      final response = await supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({
        'UserId': supabaseClient.auth.currentUser!.id,
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

  Future<int?> getRequestCount() async {
    try {
      final response =
          await supabaseClient.from('UserFriendList').select().match({
        'IsRequestPending': true,
        'FriendId': supabaseClient.auth.currentUser!.id,
      }) as List;

      return response.length;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getRequestFriendList() async {
    final List<UserModel> requestfriendList = [];
    try {
      final response =
          await supabaseClient.from('UserFriendList').select().match({
        'IsRequestPending': true,
        'FriendId': supabaseClient.auth.currentUser!.id,
      });
      for (var i in response) {
        final requestFriend = await supabaseClient
            .from('Users')
            .select()
            .eq('Id', i['UserId'])
            .maybeSingle() as Map;
        UserModel temp = UserModel(
            Id: requestFriend['Id'],
            DisplayName: requestFriend['DisplayName'],
            Email: requestFriend['Email'],
            ProfilePicUrl: requestFriend['ProfilePictureURL']);
        requestfriendList.add(temp);
      }
      return requestfriendList;
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  Future getPendingFriendList() async {
    List<UserModel> pendingfriendList = [];
    try {
      final response = await supabaseClient
          .from('UserFriendList')
          .select('Users(Id, DisplayName, Email, ProfilePictureURL)')
          .match({
        'IsRequestPending': true,
        'UserId': supabaseClient.auth.currentUser!.id
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
      if (email == supabaseClient.auth.currentUser?.email) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'You Cant Add Yourself As Friend');
        return;
      }

      final response = await supabaseClient
          .from('Users')
          .select()
          .match({'Email': email}).maybeSingle() as Map?;
      if (response == null) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'There Is No User With This Email');
        return;
      }

      final checker = await supabaseClient
          .from('UserFriendList')
          .select()
          .match({
        'FriendId': response['Id'],
        'UserId': supabaseClient.auth.currentUser!.id
      }).maybeSingle() as Map?;
      if (checker != null && checker['IsRequestPending'] == false) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'You Already Be Friend With ${response['DisplayName']}');
        return;
      } else if (checker != null && checker['IsRequestPending'] == true) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'You Already Send a Friend Request to ${response['DisplayName']}');
        return;
      }

      await supabaseClient.from('UserFriendList').insert({
        'UserId': supabaseClient.auth.currentUser!.id,
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

  Future acceptRequest(UserModel userModel) async {
    try {
      final response =
          await supabaseClient.from('UserFriendList').select().match({
        'IsRequestPending': true,
        'FriendId': supabaseClient.auth.currentUser!.id,
        'UserId': userModel.Id
      }).maybeSingle() as Map?;

      if (response == null) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'Friend Already Accepted');
        return;
      }

      await supabaseClient
          .from('UserFriendList')
          .update({'IsRequestPending': false}).match({'Id': response['Id']});

      await supabaseClient.from('UserFriendList').insert({
        'UserId': supabaseClient.auth.currentUser!.id,
        'FriendId': userModel.Id,
        'IsRequestPending': false
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

  Future rejectRequest(UserModel userModel) async {
    try {
      final response =
          await supabaseClient.from('UserFriendList').select().match({
        'IsRequestPending': true,
        'FriendId': supabaseClient.auth.currentUser!.id,
        'UserId': userModel.Id
      }).maybeSingle() as Map?;

      if (response == null) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'Friend Already Deleted');
        return;
      }
      await supabaseClient
          .from('UserFriendList')
          .delete()
          .match({'Id': response['Id']});
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
          await supabaseClient.from('UserFriendList').select().match({
        'UserId': supabaseClient.auth.currentUser!.id,
        'FriendId': userModel.Id,
        'IsRequestPending': true,
      }).maybeSingle() as Map?;

      if (checker == null) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'Friend Already Deleted');
        return;
      }

      await supabaseClient.from('UserFriendList').delete().match({
        'UserId': supabaseClient.auth.currentUser!.id,
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

  Future deleteFriend(UserModel userModel) async {
    try {
      final link1 = await supabaseClient.from('UserFriendList').select().match({
        'UserId': supabaseClient.auth.currentUser!.id,
        'FriendId': userModel.Id,
        'IsRequestPending': false
      }).maybeSingle() as Map?;
      final link2 = await supabaseClient.from('UserFriendList').select().match({
        'UserId': userModel.Id,
        'FriendId': supabaseClient.auth.currentUser!.id,
        'IsRequestPending': false
      }).maybeSingle() as Map?;

      if (link1 == null || link2 == null) {
        if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: getColorFromHex(COLOR_5),
            colorText: Colors.white,
            unexpectedErrorText,
            'Error Occured');
        return;
      }

      await supabaseClient
          .from('UserFriendList')
          .delete()
          .match({'Id': link1['Id']});
      await supabaseClient
          .from('UserFriendList')
          .delete()
          .match({'Id': link2['Id']});
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
