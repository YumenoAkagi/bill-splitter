import 'package:bill_splitter/app/modules/Friend/controllers/manage_friend_controller.dart';
import 'package:get/get.dart';

class ManageFriendBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(
      () => ManageFriendController(),
    );
  }
}
