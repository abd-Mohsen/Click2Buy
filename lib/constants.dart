import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

String kLogoPath = "assets/images/logo.png";

String? get currentLang => GetStorage().read("lang");

String get kFontFamily {
  if (currentLang == "ar") {
    return "KufiArabic";
  } else if (currentLang == "en") {
    return "defaultEnglish";
  } else {
    return "KufiArabic";
  }
}

TextStyle kTextStyle50 = TextStyle(fontSize: 50, fontFamily: kFontFamily);
TextStyle kTextStyle30 = TextStyle(fontSize: 30, fontFamily: kFontFamily);
TextStyle kTextStyle30Bold = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle26 = TextStyle(fontSize: 26, fontFamily: kFontFamily);
TextStyle kTextStyle26Bold = TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle24 = TextStyle(fontSize: 24, fontFamily: kFontFamily);
TextStyle kTextStyle24Bold = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle22 = TextStyle(fontSize: 22, fontFamily: kFontFamily);
TextStyle kTextStyle22Bold = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle20 = TextStyle(fontSize: 20, fontFamily: kFontFamily);
TextStyle kTextStyle20Bold = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle18 = TextStyle(fontSize: 18, fontFamily: kFontFamily);
TextStyle kTextStyle18Bold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle17 = TextStyle(fontSize: 17, fontFamily: kFontFamily);
TextStyle kTextStyle16 = TextStyle(fontSize: 16, fontFamily: kFontFamily);
TextStyle kTextStyle16Bold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: kFontFamily);
TextStyle kTextStyle14 = TextStyle(fontSize: 14, fontFamily: kFontFamily);
TextStyle kTextStyle14Bold = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: kFontFamily);

Duration kTimeOutDuration = const Duration(seconds: 25);
Duration kTimeOutDuration2 = const Duration(seconds: 15);
Duration kTimeOutDuration3 = const Duration(seconds: 7);

String kHostIP = "http://10.0.2.2:8000";

AlertDialog kCloseAppDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("are you sure you want to quit the app?".tr),
      actions: [
        TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              "yes".tr,
              style: kTextStyle20.copyWith(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "no".tr,
              style: kTextStyle20,
            )),
      ],
    );

AlertDialog kSessionExpiredDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("your session has expired please login again".tr),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              "yes".tr,
              style: kTextStyle20.copyWith(color: Colors.red),
            )),
      ],
    );

Future kTimeOutDialog() => Get.defaultDialog(
      title: "error".tr,
      middleText: "operation is taking so long, please check your internet "
              "connection or try again later."
          .tr,
    );

Map<String, String> kImageHeaders = const {
  'Connection': 'keep-alive',
  // 'Cache-Control': 'no-cache',
  // 'Accept-Encoding': 'gzip, deflate, br',
  // 'Accept': '*/*',
};
