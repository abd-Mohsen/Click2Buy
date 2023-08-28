import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test1/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';
import 'package:test1/models/user_model.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key, required this.user});
  final UserModel user;

  final password = TextEditingController();
  final newPassword = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    EditProfileController ePC = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: ePC.editFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    Get.isDarkMode ? "assets/images/logo_dark.png" : "assets/images/logo_light.png",
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Edit profile'.tr,
                    style: kTextStyle22Bold.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    textController: name,
                    keyboardType: TextInputType.name,
                    //obscure: false,
                    hintText: "name".tr,
                    label: "",
                    prefixIconData: Icons.person_outline,
                    // validator: (val) {
                    //   return validateInput(name.text, 4, 15, "username");
                    // },
                    onChanged: (val) {
                      if (ePC.buttonPressed) ePC.editFormKey.currentState!.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  AuthField(
                    textController: phone,
                    keyboardType: TextInputType.phone,
                    //obscure: false,
                    hintText: "phone".tr,
                    label: "",
                    prefixIconData: Icons.phone,
                    // validator: (val) {
                    //   return validateInput(phone.text, 9, 10, "phone");
                    // },
                    onChanged: (val) {
                      if (ePC.buttonPressed) ePC.editFormKey.currentState!.validate();
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'change password'.tr,
                    style: kTextStyle22Bold.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                  ),
                  const SizedBox(height: 15),
                  GetBuilder<EditProfileController>(
                    builder: (con) => AuthField(
                      textController: password,
                      keyboardType: TextInputType.text,
                      obscure: !con.passwordVisible,
                      hintText: "old password".tr,
                      label: "password",
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      onIconPress: () {
                        con.togglePasswordVisibility(!con.passwordVisible);
                      },
                      onChanged: (val) {
                        if (con.buttonPressed) con.editFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<EditProfileController>(
                    builder: (con) => AuthField(
                      textController: newPassword,
                      keyboardType: TextInputType.text,
                      obscure: !con.newPasswordVisible,
                      hintText: "enter new password".tr,
                      label: "",
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: con.newPasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      onIconPress: () {
                        con.toggleNewPasswordVisibility(!con.newPasswordVisible);
                      },
                      // validator: (val) {
                      //   return validateInput(newPassword.text, 4, 50, "password");
                      // },
                      onChanged: (val) {
                        if (con.buttonPressed) con.editFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  GetBuilder<EditProfileController>(
                    builder: (con) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AuthButton(
                        widget: con.isLoadingEdit
                            ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                            : Text(
                                "Save".tr,
                                style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                              ),
                        onTap: () {
                          con.saveChanges(name.text, phone.text, password.text, newPassword.text);
                          hideKeyboard(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
