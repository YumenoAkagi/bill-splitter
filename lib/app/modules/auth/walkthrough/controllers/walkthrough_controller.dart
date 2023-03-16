import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';

class WalkthroughController extends GetxController {
  final imageWithTextList = [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset('assets/images/undraw_Transfer_money.png'),
        Column(
          children: [
            Text(
              'Add New Transaction',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Text(
              'You can easily add transaction and track them.',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleSmall,
            ),
          ],
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset('assets/images/undraw_Mobile_payments.png'),
        Column(
          children: [
            Text(
              'Split Your Transaction',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Text(
              'Transaction that have been added can be split with your friend.',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleSmall,
            ),
          ],
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset('assets/images/undraw_Receipt.png'),
        Column(
          children: [
            Text(
              'Pay Your Bill',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Text(
              'Members can easily upload their proof of payment to the transaction.',
              textAlign: TextAlign.center,
              style: Get.textTheme.titleSmall,
            ),
          ],
        ),
      ],
    ),
  ];
}
