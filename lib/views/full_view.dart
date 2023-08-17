import 'package:flutter/material.dart';
import 'package:test1/components/custom/abd_icons_icons.dart';
import 'package:test1/components/product_card.dart';
import 'package:get/get.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/product_row_model.dart';
import '../controllers/cart_controller.dart';
import '../controllers/full_view_controller.dart';
import 'cart_view.dart';

class FullView extends StatelessWidget {
  const FullView({super.key, required this.productRowModel});
  final ProductRowModel productRowModel;

  /// shows when clicking "see more"

  //todo: fix local filter here
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    Get.put(FullViewController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          productRowModel.rowName,
          style: kTextStyle24.copyWith(color: cs.onSurface),
        ),
        backgroundColor: cs.surface,
        actions: [
          GetBuilder<CartController>(
            init: CartController(),
            builder: (con) => Center(
              child: IconButton(
                onPressed: () {
                  Get.to(const CartView());
                },
                icon: Badge(
                  backgroundColor: Colors.blueAccent,
                  label: Text(con.totalProductsAmount.toString()),
                  isLabelVisible: con.cart.isNotEmpty,
                  child: Icon(Icons.shopping_cart_outlined, size: 30, color: cs.onSurface),
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: GetBuilder<FullViewController>(
          builder: (con) => Column(
            children: [
              ExpansionTile(
                //initiallyExpanded: true,
                backgroundColor: Get.isDarkMode ? cs.surface : Colors.grey[200],
                collapsedBackgroundColor: cs.primary,
                collapsedTextColor: cs.onPrimary,
                collapsedIconColor: cs.onPrimary,
                leading: const Icon(AbdIcons.filter),
                title: Text(
                  "filter".tr,
                  //style: TextStyle(color: cs.primary),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.monetization_on,
                            color: cs.onBackground,
                          ),
                          title: Text("price".tr),
                          subtitle: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbColor: cs.primary,
                              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6.5),
                              trackHeight: 0.5,
                            ),
                            child: RangeSlider(
                              values: RangeValues(con.priceSliderStartValue, con.priceSliderEndValue),
                              labels: RangeLabels(
                                "${con.priceSliderStartValue.toString()}\$",
                                "${con.priceSliderEndValue.toString()}\$",
                              ),
                              min: 0.0,
                              max: 1000,
                              divisions: 100,
                              onChanged: (rangeValues) {
                                con.changePriceSliderValue(rangeValues);
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.star,
                            color: cs.onBackground,
                          ),
                          title: Text("rating".tr),
                          subtitle: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbColor: cs.primary,
                              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6.5),
                              trackHeight: 0.5,
                            ),
                            child: RangeSlider(
                              values: RangeValues(con.rateSliderStartValue, con.rateSliderEndValue),
                              labels: RangeLabels(
                                con.rateSliderStartValue.round().toString(),
                                con.rateSliderEndValue.round().toString(),
                              ),
                              min: 0,
                              max: 5,
                              divisions: 5,
                              onChanged: (rangeValues) {
                                con.changeRateSliderValue(rangeValues);
                              },
                            ),
                          ),
                        ),
                        //todo: add brand, color,materials and size
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 250),
                  itemCount: con.filteredList(productRowModel.products).length,
                  itemBuilder: (context, i) => ProductCard(
                    con.filteredList(productRowModel.products)[i],
                    productRowModel.rowName,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: cs.background,
    );
  }
}
