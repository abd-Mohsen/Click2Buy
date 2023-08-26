import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:test1/services/remote_services.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../constants.dart';
import '../views/login_page.dart';
import '../views/register_otp_screen.dart';

class RegisterController extends GetxController {
  @override
  void onClose() {
    // email.dispose();
    // password.dispose();
    // rePassword.dispose();
    // fName.dispose();
    // lName.dispose();
    // phone.dispose();
    super.onClose();
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final fName = TextEditingController();
  final lName = TextEditingController();
  final phone = TextEditingController();

  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;
  bool _isLoadingRegister = false;
  bool get isLoadingRegister => _isLoadingRegister;

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

  void toggleLoadingRegister(bool value) {
    _isLoadingRegister = value;
    update();
  }

  //todo: cant get to otp page after timed out (email is already taken)
  Future register() async {
    buttonPressed = true;
    bool isValid = registerFormKey.currentState!.validate();
    if (isValid) {
      print(fName.text);
      toggleLoadingRegister(true);
      try {
        _registerToken =
            (await RemoteServices.signUp(email.text, password.text, "${fName.text} ${lName.text}", phone.text)
                .timeout(kTimeOutDuration))!;
        _verifyUrl = (await RemoteServices.sendRegisterOtp(_registerToken).timeout(kTimeOutDuration))!;
        Get.to(() => const RegisterOTPScreen());
      } on TimeoutException {
        kTimeOutDialog();
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoadingRegister(false);
      }
    }
  }
  //--------------------------------------------------------------------------------
  //for otp

  final OtpFieldController otpController = OtpFieldController();
  final CountdownController timeController = CountdownController(autoStart: true);

  late String _registerToken;
  bool _isTimeUp = false;
  bool get isTimeUp => _isTimeUp;
  late String _verifyUrl;

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
        if (await RemoteServices.verifyRegisterOtp(_verifyUrl, _registerToken, pin).timeout(kTimeOutDuration)) {
          Get.offAll(() => const LoginPage());
          Get.defaultDialog(middleText: "account created successfully, please login".tr);
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
        _verifyUrl = (await RemoteServices.sendRegisterOtp(_registerToken).timeout(kTimeOutDuration))!;
        timeController.restart();
        otpController.clear();
        _isTimeUp = false;
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
}
