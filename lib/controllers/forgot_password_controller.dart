import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:test1/models/reset_password_model.dart';
import 'package:test1/services/remote_services.dart';
import 'package:test1/views/forgot_password_otp_screen.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../constants.dart';
import '../views/forgot_password_page2.dart';
import '../views/login_page.dart';

class ForgotPasswordController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // newPassword.dispose();
    // rePassword.dispose();
    super.onClose();
  }

  final email = TextEditingController();
  final newPassword = TextEditingController();
  final rePassword = TextEditingController();

  bool _isLoading1 = false;
  bool get isLoading1 => _isLoading1;
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  bool button1Pressed = false;

  void toggleLoading1(bool value) {
    _isLoading1 = value;
    update();
  }

  Future toOtp() async {
    button1Pressed = true;
    bool isValid = firstFormKey.currentState!.validate();
    if (isValid) {
      toggleLoading1(true);
      try {
        if (await RemoteServices.sendForgotPasswordOtp(email.text).timeout(kTimeOutDuration)) {
          Get.to(() => const ForgotPasswordOTPScreen());
        }
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoading1(false);
      }
    }
  }

  //--------------------------------------------------------------------------------
  //for otp screen

  final OtpFieldController otpController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);
  late String _resetToken;
  bool _isTimeUp = false;
  bool get isTimeUp => _isTimeUp;
  bool _isLoadingOtp = false;
  bool get isLoadingOtp => _isLoadingOtp;

  void toggleLoadingOtp(bool value) {
    _isLoadingOtp = value;
    update();
  }

  void toggleTimerState(bool val) {
    _isTimeUp = val;
    update();
  }

  void verifyOtp(String pin) async {
    if (_isTimeUp) {
      Get.defaultDialog(middleText: "otp time up dialog".tr);
    } else {
      toggleLoadingOtp(true);
      try {
        ResetPassModel model =
            (await RemoteServices.verifyForgotPasswordOtp(email.text, pin).timeout(kTimeOutDuration))!;
        if (model.status) {
          _resetToken = model.resetToken;
          Get.off(() => const ForgotPasswordPage2());
        } else {
          Get.defaultDialog(middleText: "wrong otp dialog".tr);
        }
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoadingOtp(false);
      }
    }
  }

  void resendOtp() async {
    if (_isTimeUp) {
      toggleLoadingOtp(true);
      try {
        await RemoteServices.sendForgotPasswordOtp(email.text).timeout(kTimeOutDuration);
        timeController.restart();
        otpController.clear();
        _isTimeUp = false;
        //update();
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoadingOtp(false);
      }
    } else {
      Get.showSnackbar(GetSnackBar(
        messageText: Text(
          "wait till time is up".tr,
          textAlign: TextAlign.center,
          style: kTextStyle14.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade800,
        duration: const Duration(milliseconds: 800),
        borderRadius: 30,
        maxWidth: 150,
        margin: const EdgeInsets.only(bottom: 50),
      ));
    }
  }

  //--------------------------------------------------------------------------------
  //for second screen

  GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  bool button2Pressed = false;
  bool _isLoading2 = false;
  bool get isLoading2 => _isLoading2;

  void toggleLoading2(bool value) {
    _isLoading2 = value;
    update();
  }

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  bool _rePasswordVisible = false;
  bool get rePasswordVisible => _rePasswordVisible;
  void toggleRePasswordVisibility(bool value) {
    _rePasswordVisible = value;
    update();
  }

  void resetPass(String password) async {
    button2Pressed = true;
    bool isValid = secondFormKey.currentState!.validate();
    if (isValid) {
      toggleLoading2(true);
      try {
        if (await RemoteServices.resetPassword(email.text, password, _resetToken).timeout(kTimeOutDuration)) {
          Get.offAll(() => const LoginPage());
          Get.defaultDialog(middleText: "reset pass dialog".tr);
        }
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoading2(false);
      }
    }
  }
}
