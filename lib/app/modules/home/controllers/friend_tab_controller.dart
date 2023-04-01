import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../providers/friend_provider.dart';

class FriendTabController extends GetxController {
  List<UserModel> friendList = [];
  final friendProvider = FriendProvider();
  Future getFriendList() async {
    final friendListFromRepo = await friendProvider.getFriendList();
    friendList = friendListFromRepo;
    update();
  }

  Future deleteFriend(UserModel userModel) async {
    await friendProvider.deleteFriend(userModel);
    friendList.clear();
    getFriendList();
  }

  @override
  void onReady() async {
    super.onReady();
    await getFriendList();
  }
}
