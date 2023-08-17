import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/cart_controller.dart';
import 'package:test1/models/address_model.dart';
import 'package:test1/models/company_model.dart';
import '../components/cart_card.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartController cC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    bool isLoggedIn = GetStorage().hasData("token");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "cart".tr,
            style: kTextStyle24Bold.copyWith(color: cs.onSurface),
          ),
          backgroundColor: cs.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.onSurface),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    backgroundColor: cs.surface,
                    title: "how to use Cart".tr,
                    titleStyle: TextStyle(color: cs.primary, wordSpacing: 5, fontWeight: FontWeight.bold, fontSize: 25),
                    middleText: "cart instructions".tr,
                    middleTextStyle: kTextStyle18.copyWith(color: cs.onSurface),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "ok",
                          style: kTextStyle20.copyWith(color: cs.primary),
                        ),
                      )
                    ],
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 30,
                  color: cs.error,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (cC.cart.isNotEmpty) {
                    Get.defaultDialog(
                      title: "clear cart?".tr,
                      titleStyle: kTextStyle30.copyWith(color: cs.error),
                      middleText: "by pressing ok your cart will be cleared".tr,
                      middleTextStyle: kTextStyle14.copyWith(color: cs.onSurface),
                      confirm: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            cC.clearCart();
                            Get.back();
                          },
                          child: Text(
                            "ok",
                            style: kTextStyle16.copyWith(color: cs.error),
                          ),
                        ),
                      ),
                      cancel: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "cancel",
                            style: kTextStyle16.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: cs.onSurface,
                )),
          ],
        ),
        backgroundColor: cs.background,
        body: GetBuilder<CartController>(
          builder: (con) => Scrollbar(
            child: ListView.builder(
              itemCount: con.cart.length,
              itemBuilder: (context, i) => CartCard(
                product: con.parents[con.cart.values.elementAt(i).id]!,
                variant: con.cart.values.elementAt(i),
                deleteCallback: () {
                  con.removeFromCart(con.cart.values.elementAt(i));
                },
                increaseCallback: () {
                  con.increaseVariantCount(con.cart.values.elementAt(i));
                },
                decreaseCallback: () {
                  con.decreaseVariantCount(con.cart.values.elementAt(i));
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            color: cs.background,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  if (cC.cart.isEmpty) {
                    Get.showSnackbar(GetSnackBar(
                      messageText: Text(
                        "your cart is empty".tr,
                        textAlign: TextAlign.center,
                        style: kTextStyle14.copyWith(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey.shade800,
                      duration: const Duration(milliseconds: 800),
                      borderRadius: 30,
                      maxWidth: 150,
                      margin: const EdgeInsets.only(bottom: 50),
                    ));
                  } else {
                    !isLoggedIn
                        ? Get.showSnackbar(GetSnackBar(
                            messageText: Text(
                              "log in first".tr,
                              textAlign: TextAlign.center,
                              style: kTextStyle14.copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey.shade800,
                            duration: const Duration(milliseconds: 800),
                            borderRadius: 30,
                            maxWidth: 150,
                            margin: const EdgeInsets.only(bottom: 50),
                          ))
                        : showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.8),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                            builder: (context) => GetBuilder<CartController>(
                                  builder: (con) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    height: 500,
                                    decoration: BoxDecoration(
                                      color: cs.surface,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text("make an order".tr,
                                              style: kTextStyle30Bold.copyWith(
                                                color: cs.primary,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 25,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: DropdownSearch<CompanyModel>(
                                              popupProps: PopupProps.menu(
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white70,
                                                    hintText: "search".tr,
                                                    prefix: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Icon(Icons.search, color: cs.onSurface),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                dropdownSearchDecoration: InputDecoration(
                                                  labelText: "delivery company".tr,
                                                  labelStyle: kTextStyle18,
                                                  hintText: "choose a company".tr,
                                                  icon: const Icon(Icons.local_shipping),
                                                ),
                                              ),
                                              items: con.companies,
                                              itemAsString: (CompanyModel c) => c.name,
                                              onChanged: (CompanyModel? company) {
                                                con.setCompany(company!);
                                              },
                                              enabled: !con.enabled,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 25,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: DropdownSearch<AddressModel>(
                                              popupProps: PopupProps.menu(
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white70,
                                                    hintText: "search".tr,
                                                    prefix: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Icon(Icons.search, color: cs.onSurface),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              dropdownDecoratorProps: DropDownDecoratorProps(
                                                dropdownSearchDecoration: InputDecoration(
                                                  labelText: "company address".tr,
                                                  hintText: "choose an address".tr,
                                                  labelStyle: kTextStyle18,
                                                  icon: const Icon(Icons.location_pin),
                                                ),
                                              ),
                                              items: con.addresses,
                                              itemAsString: (AddressModel a) => a.address[0],
                                              onChanged: (AddressModel? a) {
                                                con.setAddress(a!);
                                              },
                                              enabled: con.enabled,
                                              validator: (AddressModel? a) {
                                                if (a == null) {
                                                  return "Required field".tr;
                                                } else if (!con.enabled) {
                                                  return "choose the company first".tr;
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                            child: Scrollbar(
                                              thumbVisibility: true,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${"base total".tr}:",
                                                            style: kTextStyle20.copyWith(color: cs.onSurface),
                                                          ),
                                                          Text(
                                                            "${con.totalPrice.toPrecision(2).toString()}\$",
                                                            style: kTextStyle20.copyWith(color: cs.onSurface),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${"shipping".tr}:",
                                                            style: kTextStyle20.copyWith(color: cs.onSurface),
                                                          ),
                                                          Text(
                                                            "${(con.totalPrice / 20).toPrecision(2).toString()}\$",
                                                            style: kTextStyle20.copyWith(color: cs.onSurface),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${"Total".tr}:",
                                                            style: kTextStyle20Bold.copyWith(color: cs.onSurface),
                                                          ),
                                                          Text(
                                                            "${(con.totalPrice + con.totalPrice / 20).toPrecision(2).toString()}\$",
                                                            style: kTextStyle20Bold.copyWith(color: cs.onSurface),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              con.selected
                                                  ? cC.makeOrder()
                                                  : Get.showSnackbar(GetSnackBar(
                                                      messageText: Text(
                                                        "choose company and address first".tr,
                                                        textAlign: TextAlign.center,
                                                        style: kTextStyle14.copyWith(color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.grey.shade800,
                                                      duration: const Duration(milliseconds: 1500),
                                                      borderRadius: 30,
                                                      maxWidth: 200,
                                                      margin: const EdgeInsets.only(bottom: 50),
                                                    ));
                                            },
                                            child: !con.isLoading
                                                ? Text(
                                                    "ok".tr,
                                                    style: kTextStyle18,
                                                  )
                                                : Center(
                                                    child: SpinKitPianoWave(
                                                      color: cs.onPrimary,
                                                      duration: const Duration(milliseconds: 1000),
                                                    ),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )).then((value) {
                            cC.enabled = false;
                            cC.selected = false;
                          });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: cs.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "confirm".tr,
                          style: kTextStyle22.copyWith(color: cs.onPrimary),
                        ),
                        GetBuilder<CartController>(
                          builder: (con) => Text(
                            " (${con.totalPrice.toPrecision(2).toString()}\$) ",
                            style: kTextStyle22.copyWith(color: cs.onPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//todo: set an animation on delete
// todo: make a cart model
