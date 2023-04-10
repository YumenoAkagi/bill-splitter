import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitSuccessController extends GetxController {
  void returnToHomePage() {
    Get.offNamedUntil(Routes.HOME, ModalRoute.withName(Routes.HOME));
  }
}
