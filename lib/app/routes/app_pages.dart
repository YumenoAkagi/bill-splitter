import 'package:bill_splitter/app/modules/manage_friend/bindings/manage_friend_binding.dart';
import 'package:bill_splitter/app/modules/manage_friend/views/manage_friend_view.dart';
import 'package:get/get.dart';

import '../modules/auth/email_sent/views/email_sent_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/walkthrough/bindings/walkthrough_binding.dart';
import '../modules/auth/walkthrough/view/walkthrough_view.dart';
import '../modules/home/bindings/friend_tab_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/friends_tab_view.dart';
import '../modules/home/views/home_view.dart';
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
      name: _Paths.RECOVERY_EMAIL_SENT,
      page: () => const EmailSentView(),
    ),
    GetPage(
      name: _Paths.WALKTHROUGH,
      page: () => const WalkthroughView(),
      binding: WalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.FRIEND,
      page: () => FriendsTabView(),
      binding: FriendTabBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_FRIEND,
      page: () => ManageFriendView(),
      binding: ManageFriendBinding(),
    ),
  ];
}
