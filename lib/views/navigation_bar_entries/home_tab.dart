import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test1/components/products_row.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/home_controller.dart';
import 'package:test1/models/product_row_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController hC = Get.find();
    //ColorScheme cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: hC.refreshHome,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
              child: GetBuilder<HomeController>(builder: (con) {
                if (con.isLoadingBanners) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[200]!,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      //height: 200,
                      width: 250,
                      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                } else {
                  if (!con.isFetchedBanners) {
                    return const SizedBox.shrink();
                  } else {
                    return CarouselSlider.builder(
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
                  }
                }
              }),
            ),
          ),
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GetBuilder<HomeController>(builder: (con) {
                if (hC.isLoadingRows) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 30,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 12,
                                      width: 80,
                                      decoration:
                                          BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, i) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 225,
                                      width: 175,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 30,
                                      width: 120,
                                      decoration:
                                          BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 12,
                                      width: 80,
                                      decoration:
                                          BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, i) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[600]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 225,
                                      width: 175,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                              hC.refreshHome();
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
