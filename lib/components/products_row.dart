import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/components/product_card.dart';
import 'package:test1/models/product_row_model.dart';
import 'package:test1/views/full_view.dart';

import '../constants.dart';

class ProductsRow extends StatelessWidget {
  final ProductRowModel productRowModel;
  //final String heroTag;

  const ProductsRow({
    super.key,
    //required this.heroTag,
    required this.productRowModel,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  productRowModel.rowName,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle24Bold.copyWith(color: cs.onBackground),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(() => FullView(productRowModel: productRowModel));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "see more".tr,
                      style: kTextStyle16.copyWith(color: cs.onBackground, decoration: TextDecoration.underline),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productRowModel.products.length,
              itemBuilder: (context, i) => ProductCard(
                productRowModel.products[i],
                "${productRowModel.rowName}${productRowModel.products[i].id}",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
