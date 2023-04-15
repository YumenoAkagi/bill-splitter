import 'package:get/get.dart';

import '../../../models/transaction_proof_model.dart';
import '../../../modules/transactions/transaction_proof/controllers/transaction_proof_controller.dart';

class ImageShowController extends GetxController {
  TransactionProofModel trxProof = Get.arguments as TransactionProofModel;
}
