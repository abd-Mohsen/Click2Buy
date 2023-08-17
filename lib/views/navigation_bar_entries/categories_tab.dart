import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/components/category_card.dart';
import '../../controllers/home_controller.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  //todo: category sub views
  @override
  Widget build(BuildContext context) {
    HomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: hC.refreshParentsCategories,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GetBuilder<HomeController>(builder: (con) {
                if (hC.isLoadingCategories) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitFadingCube(
                          color: cs.primary,
                          duration: const Duration(milliseconds: 1000),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (!hC.isFetchedCat) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.network_wifi_1_bar, color: Colors.red, size: 100),
                          ElevatedButton(
                            onPressed: () {
                              hC.refreshParentsCategories();
                            },
                            child: Text("refresh"),
                          )
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: con.categoriesList.length,
                    itemBuilder: (context, i) => CategoryCard(
                      category: con.categoriesList[i],
                      heroTag: "cat${con.categoriesList[i].id}",
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
