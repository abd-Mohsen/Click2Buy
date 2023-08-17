import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/edit_order_controller.dart';

import '../components/edit_order_card.dart';
import '../constants.dart';
import '../models/address_model.dart';
import '../models/company_model.dart';
import '../models/order_model.dart';

class EditOrderView extends StatelessWidget {
  final OrderModel order;
  const EditOrderView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    EditOrderController eOC = Get.put(EditOrderController(order: order));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "edit order".tr,
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
                  title: "how to edit order".tr,
                  titleStyle: kTextStyle24Bold.copyWith(color: cs.primary),
                  middleText: "edit order dialog".tr,
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
        ],
      ),
      backgroundColor: cs.background,
      body: GetBuilder<EditOrderController>(
        builder: (con) => Scrollbar(
          thumbVisibility: true,
          child: ListView(
            children: [
              Padding(
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
              Padding(
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
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: order.variants.length,
                  itemBuilder: (context, i) => EditOrderCard(
                    variant: order.variants[i],
                    deleteCallback: () {},
                    increaseCallback: () {},
                    decreaseCallback: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: con.isLoading
                      ? Center(
                          child: SpinKitSpinningLines(
                          color: cs.onPrimary,
                          size: 30,
                        ))
                      : Text("edit".tr, style: kTextStyle26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
