import 'package:flutter/material.dart';
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
          elevation: 0,
          backgroundColor: cs.background,
          title: Row(
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  Get.isDarkMode ? "assets/images/favi_dark.png" : "assets/images/favi_light.png",
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Click2Buy",
                style: kTextStyle20Bold.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          actions: [
            // IconButton(
            //   icon: Badge(
            //     //alignment: AlignmentDirectional.topStart,
            //     label: const Text("1"),
            //     child: Icon(Icons.notifications_none_outlined, size: 27, color: cs.onSurface),
            //   ),
            //   onPressed: () {
            //     //todo: make a notification page when back-end is ready
            //     //todo: flutter local notifications
            //   },
            // ),
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

        body: GetBuilder<HomeController>(
          builder: (con) => PageView(
            controller: con.navigateController,
            //physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) => con.changeTabFromPage(index),
            children: bodies,
          ),
        ),
        bottomNavigationBar: GetBuilder<HomeController>(
          builder: (con) => NavigationBarTheme(
            data: NavigationBarThemeData(),
            child: NavigationBar(
              height: 50,
              selectedIndex: con.selectedIndex,
              backgroundColor: cs.surface,
              animationDuration: const Duration(milliseconds: 250),
              indicatorColor: cs.primary.withOpacity(0.8),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (int i) {
                con.changeTabFromBar(i);
              },
              destinations: [
                GestureDetector(
                  onTap: () {
                    //con.changeTab(0);
                  },
                  child: NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    label: '',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //con.changeTab(1);
                  },
                  child: NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    label: '',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //con.changeTab(2);
                  },
                  child: NavigationDestination(
                    icon: Icon(Icons.category_outlined),
                    label: '',
                  ),
                ),
              ],
            ),
          ),
        ),
        //GetBuilder<HomeController>(
        //   builder: (con) => GNav(
        //     tabs: [
        //       GButton(
        //         icon: Icons.settings,
        //         text: "settings".tr,
        //       ),
        //       GButton(
        //         icon: Icons.home_filled,
        //         text: "home".tr,
        //       ),
        //       GButton(
        //         icon: Icons.category_rounded,
        //         text: "categories".tr,
        //       ),
        //     ],
        //     textStyle: kTextStyle18.copyWith(color: cs.onPrimary),
        //     tabMargin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        //     // rippleColor: Colors.grey[900]!,
        //     // hoverColor: Colors.grey[900]!,
        //     gap: 8,
        //     activeColor: cs.onPrimary,
        //     iconSize: 30,
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        //     tabBackgroundColor: cs.primary,
        //     selectedIndex: con.selectedIndex,
        //     backgroundColor: !Get.isDarkMode ? Colors.grey.shade200 : cs.surface,
        //     color: cs.onSurface,
        //     duration: const Duration(milliseconds: 250),
        //     onTabChange: (i) => con.changeTab(i),
        //   ),
        // ),
      ),
    );
  }
}
