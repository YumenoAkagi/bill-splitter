import 'package:bill_splitter/app/modules/home/controllers/friend_tab_controller.dart';
import 'package:get/get.dart';

class FriendTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendTabController>(
      () => FriendTabController(),
    );
  }
}
