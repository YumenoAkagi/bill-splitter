import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../providers/friend_provider.dart';

class FriendTabController extends GetxController {
  final friendProvider = FriendProvider();
  List<UserModel> friendList = [];

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getFriendList() async {
    _toggleFetchingStatus(true);
    final friendListFromRepo = await friendProvider.getFriendList();
    friendList = friendListFromRepo;
    _toggleFetchingStatus(false);
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
