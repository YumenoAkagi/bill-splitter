import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalkthroughController extends GetxController {
  final imageWithTextList = [
    Column(
      children: [
        Image.asset('assets/images/undraw_Transfer_money.png'),
        const Text('Add New Transaction'),
        const Text('You can easily add transaction and track them.')
      ],
    ),
  ];
}
