import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/components/products_row.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/home_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test1/models/product_row_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: hC.refreshAllRows,
      child: Column(
        children: [
          //todo:make banners with fixed height and width
          // todo: make banners sliver
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
              // child: PageView.builder(
              //   controller: hC.pageController,
              //   itemCount: hC.banners.length,
              //   itemBuilder: (context, i) => Container(
              //     color: cs.background,
              //     child: Align(
              //       alignment: AlignmentDirectional.topCenter,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(20),
              //         child: hC.banners[i],
              //       ),
              //     ),
              //   ),
              // ),
              child: GetBuilder<HomeController>(builder: (con) {
                return con.isLoadingBanner
                    ? SpinKitPianoWave(
                        color: cs.primary,
                        duration: const Duration(milliseconds: 1000),
                      )
                    : CarouselSlider.builder(
                        itemCount: hC.banners.length,
                        itemBuilder: (context, i, j) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(imageUrl: "$kHostIP/storage/${hC.banners[i].photo}"),
                          ),
                        ),
                        options: CarouselOptions(
                          height: 400,
                          autoPlay: true,
                        ),
                      );
              }),
            ),
          ),
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GetBuilder<HomeController>(builder: (con) {
                if (hC.isLoadingRows) {
                  return Center(
                    child: SpinKitWave(
                      color: cs.primary,
                      duration: const Duration(milliseconds: 1000),
                    ),
                  );
                } else {
                  if (!hC.isFetchedRows) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.network_wifi_1_bar, color: Colors.red, size: 100),
                          ElevatedButton(
                            onPressed: () {
                              hC.refreshAllRows();
                            },
                            child: Text("refresh"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    List<ProductRowModel> filtered = con.rowsList.where((row) => row.products.isNotEmpty).toList();
                    return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) => ProductsRow(productRowModel: filtered[i]));
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
