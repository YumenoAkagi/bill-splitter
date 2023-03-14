import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WalkthroughView extends StatelessWidget {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
          // child: CarouselSlider(items: , options: options),
          ),
    );
  }
}
