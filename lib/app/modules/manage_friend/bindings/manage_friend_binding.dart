import 'package:bill_splitter/app/modules/manage_friend/controllers/manage_friend_controller.dart';
import 'package:get/get.dart';

class ManageFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ManageFriendController(),
    );
  }
}
