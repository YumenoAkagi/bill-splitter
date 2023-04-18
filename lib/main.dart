import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_constants.dart';
import 'app/utils/app_themedata_dark.dart';
import 'app/utils/app_themedata_light.dart';
import 'app/utils/functions_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // init supabase client
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );
  Get.put<GetStorage>(GetStorage());

  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId(dotenv.env['ONESIGNAL_APP_ID']!);
  await OneSignal.shared.promptUserForPushNotificationPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      GlobalLoaderOverlay(
        disableBackButton: true,
        useDefaultLoading: false,
        overlayWidget: Center(
          child: showCustomCircularProgressIndicator(),
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: APP_NAME,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: ThemeData(
            fontFamily: MAIN_FONT,
            appBarTheme: appBarThemeLight,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            filledButtonTheme: filledButtonThemeDataLight,
            elevatedButtonTheme: elevatedButtonThemeDataLight,
            outlinedButtonTheme: outlinedButtonThemeDataLight,
            textTheme: textThemeLight,
            inputDecorationTheme: inputDecorationThemeLight,
          ),
          darkTheme: ThemeData(
            fontFamily: MAIN_FONT,
            appBarTheme: appBarThemeDark,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: getColorFromHex(COLOR_DARK_MAIN),
            filledButtonTheme: filledButtonThemeDataDark,
            elevatedButtonTheme: elevatedButtonThemeDataDark,
            outlinedButtonTheme: outlinedButtonThemeDataDark,
            textTheme: textThemeDark,
            inputDecorationTheme: inputDecorationThemeDark,
          ),
          themeMode: ThemeMode.light,
        ),
      ),
    ),
  );
}
