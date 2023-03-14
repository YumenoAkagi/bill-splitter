import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardTabView extends StatelessWidget {
  const DashboardTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return const Center(
      child: Text('Dashboard Tab View'),
    );
  }
}
