import '../modules/transactions/transaction_proof/bindings/transaction_proof_binding.dart';
import '../modules/transactions/transaction_proof/views/transaction_proof_view.dart';
import '../widgets/image_show/bindings/image_show_binding.dart';
import '../widgets/image_show/views/image_show_view.dart';
import 'package:get/get.dart';

import '../middlewares/auth_middleware.dart';
import '../modules/auth/change_password/bindings/change_password_bindings.dart';
import '../modules/auth/change_password/bindings/done_change_password_bindings.dart';
import '../modules/auth/change_password/views/change_password_view.dart';
import '../modules/auth/change_password/views/done_change_password_view.dart';
import '../modules/auth/email_sent/bindings/email_sent_binding.dart';
import '../modules/auth/email_sent/views/email_sent_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/reset_password/bindings/reset_password_binding.dart';
import '../modules/auth/reset_password/views/reset_password_view.dart';
import '../modules/auth/walkthrough/bindings/walkthrough_binding.dart';
import '../modules/auth/walkthrough/views/walkthrough_view.dart';
import '../modules/configs/bindings/configs_binding.dart';
import '../modules/configs/views/configs_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/manage_friend/bindings/manage_friend_binding.dart';
import '../modules/manage_friend/views/manage_friend_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/transactions/add_transactions_detail_members/bindings/add_trx_detail_members_binding.dart';
import '../modules/transactions/add_transactions_detail_members/views/add_trx_detail_members_view.dart';
import '../modules/transactions/add_transactions_details_items/bindings/add_item_manual_binding.dart';
import '../modules/transactions/add_transactions_details_items/bindings/add_item_ocr_binding.dart';
import '../modules/transactions/add_transactions_details_items/bindings/add_trx_details_items_binding.dart';
import '../modules/transactions/add_transactions_details_items/views/add_item_manual_view.dart';
import '../modules/transactions/add_transactions_details_items/views/add_item_ocr_view.dart';
import '../modules/transactions/add_transactions_details_items/views/add_trx_details_items_view.dart';
import '../modules/transactions/history_transactions/bindings/history_transactions_binding.dart';
import '../modules/transactions/history_transactions/views/history_transactions_view.dart';
import '../modules/transactions/split_success/bindings/split_success_binding.dart';
import '../modules/transactions/split_success/views/split_success_view.dart';
import '../modules/transactions/split_transactions_options/bindings/split_trx_options_binding.dart';
import '../modules/transactions/split_transactions_options/views/split_trx_options_view.dart';
import '../modules/transactions/split_trx_by_item/bindings/split_trx_by_item_binding.dart';
import '../modules/transactions/split_trx_by_item/views/split_trx_by_item_view.dart';
import '../modules/transactions/transactions_detail/bindings/transaction_detail_binding.dart';
import '../modules/transactions/transactions_detail/views/transaction_detail_view.dart';
import '../modules/transactions/who_paid_trx_bill/bindings/who_paid_trx_binding.dart';
import '../modules/transactions/who_paid_trx_bill/views/who_paid_trx_bill_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_RECOVERY,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RECOVERY_EMAIL_SENT,
      page: () => const EmailSentView(),
      binding: EmailSentBinding(),
    ),
    GetPage(
      name: _Paths.WALKTHROUGH,
      page: () => const WalkthroughView(),
      binding: WalkthroughBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 625),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 750),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.MANAGE_FRIEND,
      page: () => const ManageFriendView(),
      binding: ManageFriendBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.CONFIGS,
      page: () => const ConfigsView(),
      binding: ConfigsBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.HISTORYTRX,
      page: () => const HistoryTransactionsView(),
      binding: HistoryTransactionsBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.ADDTRXITEM,
      page: () => const AddTrxDetailsItemsView(),
      binding: AddTrxDetailsItemsBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
      children: [
        GetPage(
          name: _Paths.ADDITEMMANUAL,
          page: () => const AddItemManualView(),
          binding: AddItemManualBinding(),
        ),
        GetPage(
          name: _Paths.ADDITEMOCR,
          page: () => const AddItemOCRView(),
          binding: AddItemOCRBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ADDTRXMEMBERS,
      page: () => const AddTrxDetailMembersView(),
      binding: AddTrxDetailMembersBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.TRXMEMBERWHOPAID,
      page: () => const WhoPaidTrxBillView(),
      binding: WhoPaidTrxBillBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.TRXSPLITOPTIONS,
      page: () => const SplitTrxOptionsView(),
      binding: SplitTrxOptionsBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
      children: [
        GetPage(
          name: _Paths.TRXASSIGNMEMBERTOITEM,
          page: () => const SplitTrxByItemView(),
          binding: SplitTrxByItemBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPLITSUCCESS,
      page: () => const SplitSuccessView(),
      binding: SplitSuccessBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.TRXDETAIL,
      page: () => const TransactionDetailView(),
      binding: TransactionDetailBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.TRXPROOFS,
      page: () => const TransactionProofView(),
      binding: TransactionProofBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DONE_CHANGE_PASSWORD,
      page: () => const DoneChangePasswordView(),
      binding: DoneChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.SHOWIMAGE,
      page: () => const ImageShowView(),
      binding: ImageShowBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
  ];
}
