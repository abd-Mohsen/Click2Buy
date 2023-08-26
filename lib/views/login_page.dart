import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:test1/views/home_view.dart';
import 'package:get/get.dart';
import 'package:test1/views/register_view.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';
import 'forgot_password_page1.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    LoginController lC = Get.put(LoginController());
    return WillPopScope(
      onWillPop: () async {
        Get.dialog(kCloseAppDialog());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: lC.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Hero(
                      tag: "logo",
                      child: Image.asset(
                        kLogoPath,
                        height: MediaQuery.of(context).size.width / 2.5,
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome back!'.tr,
                      style: kTextStyle16.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                    ),
                    const SizedBox(height: 25),
                    AuthField(
                      textController: lC.email,
                      keyboardType: TextInputType.emailAddress,
                      //obscure: false,
                      hintText: "email".tr,
                      label: "email",
                      prefixIconData: Icons.email_outlined,
                      validator: (val) {
                        return validateInput(lC.email.text, 4, 100, "email");
                      },
                      onChanged: (val) {
                        if (lC.buttonPressed) lC.loginFormKey.currentState!.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    GetBuilder<LoginController>(
                      builder: (con) => AuthField(
                        textController: lC.password,
                        keyboardType: TextInputType.text,
                        obscure: !con.passwordVisible,
                        hintText: "password".tr,
                        label: "password",
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        onIconPress: () {
                          con.togglePasswordVisibility(!con.passwordVisible);
                        },
                        validator: (val) {
                          return validateInput(lC.password.text, 4, 50, "password");
                        },
                        onChanged: (val) {
                          if (con.buttonPressed) con.loginFormKey.currentState!.validate();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ForgotPasswordPage1());
                            },
                            child: Text(
                              'Forgot Password?'.tr,
                              style: kTextStyle14.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    GetBuilder<LoginController>(
                      builder: (con) => AuthButton(
                        widget: con.isLoading
                            ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                            : Text(
                                "Sign In".tr,
                                style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                              ),
                        onTap: () {
                          con.login();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    AuthButton(
                      widget: Text(
                        "continue as guest".tr,
                        style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: "warning".tr,
                          titleStyle: kTextStyle24.copyWith(color: cs.primary),
                          middleText: "guest warning".tr,
                          middleTextStyle: kTextStyle18.copyWith(color: cs.onSurface),
                          confirm: TextButton(
                            onPressed: () {
                              Get.offAll(() => const HomeView());
                            },
                            child: Text(
                              "continue".tr,
                              style: kTextStyle20.copyWith(color: cs.primary),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "don't have an account?".tr,
                          style: kTextStyle18.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const RegisterView());
                          },
                          child: Text(
                            'Register now'.tr,
                            style: kTextStyle18Bold.copyWith(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
