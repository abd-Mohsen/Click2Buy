import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:test1/controllers/register_controller.dart';
import 'package:get/get.dart';
import 'package:test1/views/login_page.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    RegisterController rC = Get.put(RegisterController());

    return WillPopScope(
      onWillPop: () async {
        Get.dialog(kCloseAppDialog());
        return false;
      },
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: rC.registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Hero(
                      tag: "logo",
                      child: Image.asset(
                        kLogoPath,
                        height: MediaQuery.of(context).size.width / 2.7,
                        width: MediaQuery.of(context).size.width / 2.7,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'create a new account'.tr,
                      style: kTextStyle16.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                    ),
                    const SizedBox(height: 25),
                    AuthField(
                      textController: rC.fName,
                      keyboardType: TextInputType.name,
                      //obscure: false,
                      hintText: "first name (in english)".tr,
                      label: "",
                      prefixIconData: Icons.person_outline,
                      validator: (val) {
                        return validateInput(rC.fName.text, 4, 15, "username");
                      },
                      onChanged: (val) {
                        if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    AuthField(
                      textController: rC.lName,
                      keyboardType: TextInputType.name,
                      //obscure: false,
                      hintText: "last name(optional)".tr,
                      label: "",
                      prefixIconData: Icons.person,
                      validator: (val) {
                        return null;
                        //return validateInput(lastName.text, 4, 15, "username");
                      },
                      onChanged: (val) {
                        //if (rC.button1Pressed) rC.registerFormKey.currentState!.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    AuthField(
                      textController: rC.email,
                      keyboardType: TextInputType.emailAddress,
                      //obscure: false,
                      hintText: "email".tr,
                      label: "email",
                      prefixIconData: Icons.email_outlined,
                      validator: (val) {
                        return validateInput(rC.email.text, 4, 100, "email");
                      },
                      onChanged: (val) {
                        if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                      },
                    ),
                    const SizedBox(height: 10),
                    GetBuilder<RegisterController>(
                      builder: (con) => AuthField(
                        textController: rC.password,
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
                          return validateInput(rC.password.text, 4, 50, "password");
                        },
                        onChanged: (val) {
                          if (con.buttonPressed) con.registerFormKey.currentState!.validate();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    GetBuilder<RegisterController>(
                      builder: (con) => AuthField(
                        textController: rC.rePassword,
                        keyboardType: TextInputType.text,
                        obscure: !con.rePasswordVisible,
                        hintText: "re enter password".tr,
                        label: "",
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: con.rePasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        onIconPress: () {
                          con.toggleRePasswordVisibility(!con.rePasswordVisible);
                        },
                        validator: (val) {
                          return validateInput(rC.rePassword.text, 4, 50, "password",
                              pass: rC.password.text, rePass: rC.rePassword.text);
                        },
                        onChanged: (val) {
                          if (con.buttonPressed) con.registerFormKey.currentState!.validate();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: IntlPhoneField(
                        controller: rC.phone,
                        //todo: validator isn't working well with phone field
                        validator: (val) {
                          return validateInput(rC.phone.text, 9, 10, "phone");
                        },
                        onChanged: (val) {
                          if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                        },
                        style: kTextStyle14.copyWith(color: Colors.black),
                        dropdownTextStyle: kTextStyle14.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: "phone".tr,
                            //counterText: ,
                            //errorText: "invalid number".tr,
                            hintStyle: kTextStyle14.copyWith(color: Colors.grey[500])),
                        initialCountryCode: 'SY',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 25),
                    GetBuilder<RegisterController>(
                      builder: (con) => AuthButton(
                        widget: con.isLoadingRegister
                            ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                            : Text(
                                "Register".tr,
                                style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                              ),
                        onTap: () {
                          //if (password.text == rePassword.text) {
                          con.toggleTimerState(false);
                          con.register();
                          hideKeyboard(context);
                          // } else {
                          //   Get.defaultDialog(middleText: "passwords are not matched");
                          // }
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already have an account?".tr,
                          style: kTextStyle14.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.off(() => const LoginPage());
                          },
                          child: Text(
                            'Login now'.tr,
                            style: kTextStyle14Bold.copyWith(color: Colors.blue),
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
