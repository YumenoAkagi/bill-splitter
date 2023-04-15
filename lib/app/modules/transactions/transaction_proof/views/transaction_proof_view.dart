import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../controllers/transaction_proof_controller.dart';

class TransactionProofView extends GetView<TransactionProofController> {
  const TransactionProofView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmations'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: GetBuilder<TransactionProofController>(
            builder: (tpc) => tpc.isFetching
                ? showFetchingScreen()
                : tpc.trxProofs.isEmpty
                    ? const Center(
                        child: Text('No data'),
                      )
                    : ListView.separated(
                        itemCount: tpc.trxProofs.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                tpc.trxProofs[index].fromUser.id ==
                                        supabaseClient.auth.currentUser!.id
                                    ? 'You paid ${moneyFormatter.format(tpc.trxProofs[index].paidAmount)} to ${tpc.trxProofs[index].fromUser.displayName}'
                                    : '${tpc.trxProofs[index].fromUser.displayName} paid ${moneyFormatter.format(tpc.trxProofs[index].paidAmount)} to you',
                              ),
                              subtitle: Text(tpc.trxProofs[index].createdDate),
                            ),
                            tpc.trxProofs[index].imgUrl == null
                                ? const SizedBox()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: 50 * GOLDEN_RATIO,
                                      width: 50 * GOLDEN_RATIO,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.SHOWIMAGE,
                                            arguments: tpc.trxProofs[index],
                                          );
                                        },
                                        child: Hero(
                                          tag: tpc.trxProofs[index].id,
                                          child: Image.network(
                                            tpc.trxProofs[index].imgUrl!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
