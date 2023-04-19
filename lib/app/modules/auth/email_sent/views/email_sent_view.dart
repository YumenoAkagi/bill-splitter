import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';

class EmailSentView extends StatelessWidget {
  const EmailSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/undraw_Mail_sent.png'),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Text(
                'Email Sent',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              Text(
                'Reset Password link has been sent. Please check your email to continue reset your password',
                style: Get.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              FilledButton(
                onPressed: () {
                  Get.offNamed(Routes.LOGIN);
                },
                child: const Text('Back to login page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
