import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/controllers/locale_controller.dart';
import 'package:test1/themes.dart';
import 'package:test1/views/welcome_screen.dart';
import 'locale.dart';
import 'controllers/theme _controller.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) => super.createHttpClient(context)..maxConnectionsPerHost = 5;
}

void main() async {
  //await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

///some self notes
//todo: pagination
//todo: localize all text

//todo: about/contact us in settings
//todo: for all network pics add a default image if its null

//less important
//todo: use secure storage for token
//todo: try BLoC
//todo: release apk /android apk analyzer/dart dev tools
//todo: make an ios version
//todo: responsive design
//todo: make sliver pic with sliver appbar in product view
//todo: change fonts for both ar and en
//todo: optimize routes and controllers
// todo: make a twitter like snack_bars (one for home and one for inner pages)

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeController t = Get.put(ThemeController()); //to get the initial theme
    LocaleController l = LocaleController(); //to get the initial language
    return GetMaterialApp(
      translations: MyLocale(),
      locale: l.initialLang,
      title: 'E-commerce Demo',
      home: const WelcomeScreen(),
      theme: MyThemes.myLightMode, //custom light theme
      darkTheme: MyThemes.myDarkMode, //custom dark theme
      themeMode: t.getThemeMode(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          ///to make text factor 1 for all text widgets (user cant fuck it up from phone settings)
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1, devicePixelRatio: 1),
          child: child!,
        );
      },
    );
  }
}
