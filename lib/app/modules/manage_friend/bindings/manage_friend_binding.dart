import 'package:get/get.dart';

import '../controllers/manage_friend_controller.dart';

class ManageFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ManageFriendController(),
    );
  }
}
