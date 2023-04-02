import 'package:bill_splitter/app/modules/configs/bindings/configs_binding.dart';
import 'package:bill_splitter/app/modules/configs/views/configs_view.dart';
import 'package:bill_splitter/app/modules/transactions/add_transactions_details_items/bindings/add_item_manual_binding.dart';
import 'package:bill_splitter/app/modules/transactions/add_transactions_details_items/bindings/add_trx_details_items_binding.dart';
import 'package:bill_splitter/app/modules/transactions/add_transactions_details_items/views/add_item_manual_view.dart';
import 'package:bill_splitter/app/modules/transactions/add_transactions_details_items/views/add_trx_details_items_view.dart';
import 'package:bill_splitter/app/modules/transactions/history_transactions/bindings/history_transactions_binding.dart';
import 'package:bill_splitter/app/modules/transactions/history_transactions/views/history_transactions_view.dart';
import 'package:get/get.dart';

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
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/manage_friend/bindings/manage_friend_binding.dart';
import '../modules/manage_friend/views/manage_friend_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

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
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 750),
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
      name: _Paths.MANAGE_FRIEND,
      page: () => const ManageFriendView(),
      binding: ManageFriendBinding(),
    ),
    GetPage(
      name: _Paths.CONFIGS,
      page: () => const ConfigsView(),
      binding: ConfigsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORYTRX,
      page: () => const HistoryTransactionsView(),
      binding: HistoryTransactionsBinding(),
    ),
    GetPage(
      name: _Paths.ADDTRXITEM,
      page: () => const AddTrxDetailsItemsView(),
      binding: AddTrxDetailsItemsBinding(),
      children: [
        GetPage(
          name: _Paths.ADDITEMMANUAL,
          page: () => const AddItemManualView(),
          binding: AddItemManualBinding(),
        ),
      ],
    ),
  ];
}
