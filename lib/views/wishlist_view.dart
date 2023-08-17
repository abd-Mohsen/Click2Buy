import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/components/wishlist_card.dart';
import 'package:test1/controllers/wishlist_controller.dart';

import '../constants.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    WishlistController wC = Get.put(WishlistController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "wishlist".tr,
          style: kTextStyle24Bold.copyWith(color: cs.onSurface),
        ),
        backgroundColor: cs.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: cs.background,
      body: RefreshIndicator(
        onRefresh: wC.refreshProducts,
        child: GetBuilder<WishlistController>(
          builder: (con) {
            if (con.isLoading) {
              return Center(
                child: SpinKitPumpingHeart(
                  color: cs.primary,
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            } else {
              if (!con.isFetched) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.network_wifi_1_bar, color: Colors.red, size: 100),
                      ElevatedButton(
                        onPressed: () {
                          con.refreshProducts();
                        },
                        child: Text("refresh"),
                      ),
                    ],
                  ),
                );
              } else {
                return con.wishlist.isNotEmpty
                    ? ListView.builder(
                        itemCount: con.wishlist.length,
                        itemBuilder: (context, i) => WishlistCard(
                          product: con.wishlist[i].product[0],
                          onDelete: () {
                            con.deleteProduct(con.wishlist[i]);
                          },
                        ),
                      )
                    : Center(child: Text("wishlist is empty".tr, style: kTextStyle20));
              }
            }
          },
        ),
      ),
    );
  }
}
