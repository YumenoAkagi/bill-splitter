import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_constants.dart';

class WalkthroughView extends StatelessWidget {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    var imageWidget = <Widget>[];
    imageWidget.insert(imageWidget.length,
        Image.asset('assets/images/undraw_Mobile_payments.png'));
    imageWidget.insert(
        imageWidget.length, Image.asset('assets/images/undraw_Receipt.png'));
    imageWidget.insert(imageWidget.length,
        Image.asset('assets/images/undraw_Transfer_money.png'));
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(autoPlay: true),
          items: imageWidget,
        ),
      ),
    );
  }
}
