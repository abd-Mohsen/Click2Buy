import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/services/remote_services.dart';

class EditProfileController extends GetxController {
  final GetStorage _getStorage = GetStorage();
  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;
  bool _isLoadingEdit = false;
  bool get isLoadingEdit => _isLoadingEdit;

  void toggleLoadingEdit(bool value) {
    _isLoadingEdit = value;
    update();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  bool _newPasswordVisible = false;
  bool get newPasswordVisible => _newPasswordVisible;
  void toggleNewPasswordVisibility(bool value) {
    _newPasswordVisible = value;
    update();
  }

  void saveChanges(String name, String phone, String oldPass, String newPass) async {
    buttonPressed = true;
    bool isValid = editFormKey.currentState!.validate();
    if (isValid) {
      toggleLoadingEdit(true);
      try {
        bool first = false, second = false;
        if (oldPass.isNotEmpty && newPass.isNotEmpty) {
          first = await RemoteServices.changePassword(oldPass, newPass, _getStorage.read("token"));
        }
        if (name.isNotEmpty && phone.isNotEmpty) {
          second = await RemoteServices.editProfile(name, phone, _getStorage.read("token"));
        }
        if (first || second) {
          Get.back();
          Get.defaultDialog(title: "success".tr, middleText: "changes will take effect in seconds");
        }
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        print(e.toString());
      } finally {
        toggleLoadingEdit(false);
      }
    }
  }
}
