import 'package:bill_splitter/app/widgets/friendBottomSheet/controllers/friend_bottom_sheet_controller.dart';
import 'package:get/get.dart';

class FriendBottomSheetBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(
      () => FriendBottomSheetController(),
    );
  }
}
