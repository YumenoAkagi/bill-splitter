import 'package:bill_splitter/app/modules/login/controllers/login_controller.dart';

import '../../../utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/zocial_icons.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HomeView is working',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(
                Zocial.email,
                size: BUTTON_ICON_SIZE,
              ),
              label: const Text('Sign up with Email'),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text("Already have account? Sign in"),
            ),
          ],
        ),
      ),
    );
  }
}
