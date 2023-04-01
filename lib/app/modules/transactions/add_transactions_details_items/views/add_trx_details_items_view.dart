import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_trx_details_items_controller.dart';

class AddTrxDetailsItemsView extends GetView<AddTrxDetailsItemsController> {
  const AddTrxDetailsItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.trxHeader.name),
      ),
    );
  }
}
