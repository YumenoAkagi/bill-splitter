import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_constants.dart';

class ImageWithText extends StatelessWidget {
  final String path;
  final String imageText;
  const ImageWithText(this.path, this.imageText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Image.asset(path), Text(imageText)],
    );
  }
}

class WalkthroughView extends StatelessWidget {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    //make list of custom widget
    var imageWithTextList = <Widget>[];
    imageWithTextList.insertAll(imageWithTextList.length, [
      const ImageWithText(
          'assets/images/undraw_Mobile_payments.png', 'Hello world'),
      const ImageWithText(
          'assets/images/undraw_Mobile_payments.png', 'Hello world 1'),
      const ImageWithText(
          'assets/images/undraw_Transfer_money.png', 'Hello world 2')
    ]);

    //build page
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(autoPlay: true),
          items: imageWithTextList,
        ),
      ),
    );
  }
}
