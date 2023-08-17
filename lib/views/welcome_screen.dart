import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/views/home_view.dart';
import 'package:test1/views/login_page.dart';
import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _getStorage = GetStorage();

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      _getStorage.hasData("token") ? Get.offAll(() => const HomeView()) : Get.offAll(() => LoginPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "logo",
              child: Image.asset(
                kLogoPath,
                height: MediaQuery.of(context).size.width / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Click2Buy",
              style: kTextStyle30Bold.copyWith(color: cs.onBackground),
            ),
            const SizedBox(height: 25),
            LinearProgressIndicator(color: cs.primary),
            const SizedBox(height: 50),
            Text(
              "buy any clothing online".tr,
              style: kTextStyle24.copyWith(color: cs.onBackground.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
