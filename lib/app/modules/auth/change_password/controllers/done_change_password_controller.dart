import 'package:get/get.dart';

import '../../../../utils/functions_helper.dart';

class DoneChangePassController extends GetxController {
  RxBool isLoading = false.obs;

  Future pressDoneButton() async {
    try {
      Get.back();
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }
}
