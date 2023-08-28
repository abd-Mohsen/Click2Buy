import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test1/components/auth_button.dart';
import 'package:test1/controllers/home_controller.dart';
import 'package:test1/views/login_page.dart';
import 'package:test1/views/orders_view.dart';
import '../../components/auth_field.dart';
import '../../constants.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/theme _controller.dart';
import '../wishlist_view.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    LocaleController lC = LocaleController();
    HomeController hC = Get.find();
    final password = TextEditingController();
    final bool isLoggedIn = GetStorage().hasData("token");

    return RefreshIndicator(
      onRefresh: hC.refreshUser,
      child: ListView(
        children: [
          const SizedBox(height: 15),
          isLoggedIn
              ? GetBuilder<HomeController>(
                  builder: (con) {
                    if (con.isLoadingUser) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.account_box,
                              color: cs.onSurface,
                              size: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[600]!,
                                highlightColor: Colors.grey[200]!,
                                child: Container(
                                  height: 35,
                                  width: 180,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[600]!,
                                highlightColor: Colors.grey[200]!,
                                child: Container(
                                  height: 15,
                                  width: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: cs.surface,
                            collapsedBackgroundColor: cs.surface,
                          ),
                        ),
                      );
                    } else {
                      if (!con.isFetchedUser) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ListTile(
                              tileColor: cs.surface,
                              title: Text(
                                "connection error".tr,
                                style: kTextStyle26Bold.copyWith(color: cs.error),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  con.refreshUser();
                                },
                                child: Text("refresh", style: kTextStyle18),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: ExpansionTile(
                              leading: Icon(
                                Icons.account_box,
                                color: cs.onSurface,
                                size: 30,
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  con.currentUser[0].name,
                                  style: kTextStyle30.copyWith(color: cs.onSurface),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Account details".tr,
                                  style: kTextStyle16,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                side: const BorderSide(width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: cs.surface,
                              collapsedBackgroundColor: cs.surface,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.mail,
                                          color: cs.onBackground,
                                        ),
                                        title: Text("email".tr),
                                        subtitle: Text(
                                          con.currentUser[0].email,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.phone_android,
                                          color: cs.onBackground,
                                        ),
                                        title: Text("phone".tr),
                                        subtitle: Text(
                                          con.currentUser[0].phone,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  title: Text(
                                                    "${"please enter your password first".tr}:",
                                                    style: kTextStyle18,
                                                  ),
                                                  content: Form(
                                                    key: con.settingKey,
                                                    child: GetBuilder<HomeController>(
                                                      builder: (con) => AuthField(
                                                        textController: password,
                                                        keyboardType: TextInputType.text,
                                                        obscure: !con.passwordVisible,
                                                        hintText: "password".tr,
                                                        label: "password",
                                                        prefixIconData: Icons.lock_outline,
                                                        suffixIconData: con.passwordVisible
                                                            ? CupertinoIcons.eye_slash
                                                            : CupertinoIcons.eye,
                                                        onIconPress: () {
                                                          con.togglePasswordVisibility(!con.passwordVisible);
                                                        },
                                                        validator: (val) {
                                                          return validateInput(password.text, 4, 50, "password");
                                                        },
                                                        onChanged: (val) {
                                                          if (con.buttonPressed) {
                                                            con.settingKey.currentState!.validate();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: GetBuilder<HomeController>(
                                                        builder: (con) => AuthButton(
                                                          onTap: () {
                                                            hideKeyboard(context);
                                                            con.confirmPassword(password.text);
                                                          },
                                                          widget: con.isLoadingConfirmPassword
                                                              ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                                                              : Text(
                                                                  "submit".tr,
                                                                  style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "edit".tr,
                                              style: kTextStyle22.copyWith(color: cs.primary),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      onTap: () {
                        Get.offAll(() => LoginPage());
                      },
                      tileColor: cs.surface,
                      leading: Icon(Icons.login, color: cs.primary, size: 30),
                      title: Text(
                        "login".tr,
                        style: kTextStyle24.copyWith(color: cs.onSurface),
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          isLoggedIn
              ? ListTile(
                  onTap: () {
                    //if (hC.isFetchedUser)
                    Get.to(() => const WishlistView());
                  },
                  leading: Icon(Icons.favorite, color: cs.onBackground),
                  title: Text(
                    "my wishlist".tr,
                    style: kTextStyle20.copyWith(color: cs.onBackground),
                  ),
                )
              : const SizedBox.shrink(),
          isLoggedIn
              ? ListTile(
                  onTap: () {
                    if (hC.isFetchedUser) Get.to(() => const OrdersView());
                    //else show a toast
                  },
                  leading: Icon(Icons.checklist, color: cs.onBackground),
                  title: Text(
                    "my orders".tr,
                    style: kTextStyle20.copyWith(color: cs.onBackground),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          ListTile(
            title: Text(
              "dark theme".tr,
              style: kTextStyle20.copyWith(color: cs.onBackground),
            ),
            leading: Icon(
              Icons.dark_mode_outlined,
              color: cs.onBackground,
            ),
            trailing: GetBuilder<ThemeController>(
              init: ThemeController(),
              builder: (con) => LiteRollingSwitch(
                //todo: not working with arabic remove it
                width: 90,
                textOffColor: cs.onPrimary,
                textOnColor: cs.onPrimary,
                value: con.switchValue,
                iconOn: Icons.nightlight,
                colorOff: cs.primary,
                colorOn: cs.primary,
                iconOff: CupertinoIcons.sun_min,
                onChanged: (bool value) {
                  con.updateTheme(value);
                },
                onDoubleTap: () {},
                onTap: () {},
                onSwipe: () {},
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(
              Icons.language,
              color: cs.onBackground,
            ),
            title: DropdownButton(
              elevation: 50,
              iconEnabledColor: cs.onBackground,
              dropdownColor: Get.isDarkMode ? cs.surface : Colors.grey.shade200,
              hint: Text(
                lC.getCurrentLanguageLabel(),
                style: kTextStyle20.copyWith(color: cs.onBackground),
              ),
              //button label is updating cuz whole app is rebuilt after changing locale
              items: [
                DropdownMenuItem(
                  value: "ar",
                  child: Text("Arabic ".tr),
                ),
                DropdownMenuItem(
                  value: "en",
                  child: Text("English ".tr),
                ),
              ],
              onChanged: (val) {
                lC.updateLocale(val!);
              },
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: cs.onBackground),
            title: Text(
              "privacy policy".tr,
              style: kTextStyle20.copyWith(color: cs.onBackground),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.phone, color: cs.onBackground),
            title: Text(
              "contact us".tr,
              style: kTextStyle20.copyWith(color: cs.onBackground),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.info_outlined, color: cs.onBackground),
            title: Text(
              "about".tr,
              style: kTextStyle20.copyWith(color: cs.onBackground),
            ),
          ),
          const SizedBox(height: 10),
          isLoggedIn
              ? ListTile(
                  leading: Icon(Icons.logout, color: cs.error),
                  title: Text(
                    "log out".tr,
                    style: kTextStyle20.copyWith(color: cs.error),
                  ),
                  onTap: () {
                    //clear cart ?
                    hC.logOut();
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
