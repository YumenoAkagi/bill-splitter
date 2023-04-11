import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class SplitSuccessController extends GetxController {
  void returnToHomePage() {
    Get.offAllNamed(Routes.HOME);
  }
}
