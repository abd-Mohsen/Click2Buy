import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:test1/components/custom/abd_icons_icons.dart';
import 'package:test1/constants.dart';
import 'package:test1/themes.dart';
import 'package:test1/controllers/cart_controller.dart';
import 'package:get/get.dart';
import '../components/my_search_page.dart';
import '../controllers/home_controller.dart';
import 'cart_view.dart';
import 'navigation_bar_entries/categories_tab.dart';
import 'navigation_bar_entries/home_tab.dart';
import 'navigation_bar_entries/settings_tab.dart';

// todo: make appbar sliver
// todo: make a twitter like snack_bars (one for home and one for inner pages)
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    HomeController hC = Get.put(HomeController());

    List<Widget> bodies = [
      const SettingsTab(),
      const HomeTab(),
      const CategoriesTab(),
    ];

    return WillPopScope(
      onWillPop: () async {
        Get.dialog(kCloseAppDialog());
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: cs.background,
        appBar: AppBar(
          //elevation: 0,
          backgroundColor: cs.surface,
          title: Row(
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "Ecommerce",
                style: kTextStyle18Bold.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                alignment: AlignmentDirectional.topStart,
                label: const Text("1"),
                child: Icon(Icons.notifications_none_outlined, size: 27, color: cs.onSurface),
              ),
              onPressed: () {
                hC.refreshAllRows();
                //todo: make a notification page when back-end is ready
                //todo: flutter local notifications
              },
            ),
            IconButton(
              onPressed: () {
                if (hC.isFetchedRows) {
                  showSearch(
                    context: context,
                    delegate: MySearchPage(
                      barTheme: Get.isDarkMode
                          ? MyThemes.myDarkMode
                          : MyThemes.myLightMode.copyWith(
                              appBarTheme: AppBarTheme(backgroundColor: cs.surface, foregroundColor: cs.onSurface)),
                      //i did all that cuz search color(light theme) is fucked up for no reason
                      searchLabel: "Search products".tr,
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.search,
                color: cs.onSurface,
                size: 27,
              ),
            ),
            //wrapped in a get builder to show how many products in cart
            GetBuilder<CartController>(
              init: CartController(),
              builder: (con) => Center(
                child: IconButton(
                  icon: Badge(
                    backgroundColor: Colors.blueAccent,
                    label: Text(con.totalProductsAmount.toString()),
                    isLabelVisible: con.cart.isNotEmpty,
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 27,
                      color: cs.onSurface,
                    ),
                  ),
                  onPressed: () {
                    if (hC.isFetchedRows) {
                      Get.to(() => const CartView());
                    }
                  },
                ),
              ),
            ),
          ],
        ),

        //wrapped in get builder to change scaffold body based on index from navigation bar
        //used indexed stack to not rebuild every widget from scratch when changing scaffold body
        //fade indexed stack is indexed stack but with fade animation when changing scaffold body

        body: GetBuilder<HomeController>(
          builder: (con) => PageView(
            //duration: const Duration(milliseconds: 150),
            //index: con.selectedIndex,
            controller: con.navigateController,
            onPageChanged: (int index) {
              con.changeTab(index);
            },
            //physics: const AlwaysScrollableScrollPhysics(),
            children: bodies,
          ),
        ),

        bottomNavigationBar: GetBuilder<HomeController>(
          builder: (con) => CurvedNavigationBar(
            items: [
              Icon(
                Icons.settings,
                color: cs.onSurface,
                size: 27,
              ),
              Icon(
                Icons.home,
                color: cs.onSurface,
                size: 27,
              ),
              Icon(
                AbdIcons.tags,
                color: cs.onSurface,
                size: 27,
              ),
            ],
            height: 55,
            index: con.selectedIndex,
            backgroundColor: Colors.transparent,
            color: !Get.isDarkMode ? Colors.grey.shade200 : cs.surface,
            animationDuration: const Duration(milliseconds: 250),
            onTap: (i) {
              con.changeTab(i);
            },
          ),
        ),
      ),
    );
  }
}
