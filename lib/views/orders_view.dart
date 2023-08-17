import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/orders_controller.dart';
import '../components/order_card.dart';
import '../constants.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    Get.put(OrdersController());
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: cs.onSurface),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              "my orders".tr,
              style: kTextStyle24.copyWith(color: cs.onSurface),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.access_time,
                    color: cs.onSurface,
                  ),
                  child: Text("pending".tr, style: kTextStyle14.copyWith(color: cs.onSurface)),
                ),
                Tab(
                  icon: Icon(
                    Icons.view_list,
                    color: cs.onSurface,
                  ),
                  child: Text("history".tr, style: kTextStyle14.copyWith(color: cs.onSurface)),
                ),
              ],
            ),
            backgroundColor: cs.surface,
          ),
          body: GetBuilder<OrdersController>(
            builder: (con) {
              if (con.isLoading) {
                return Center(child: SpinKitChasingDots(color: cs.primary, size: 50));
              } else {
                if (!con.isFetched) {
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.network_wifi_1_bar, color: Colors.red, size: 100),
                        ElevatedButton(
                          onPressed: () {
                            con.refreshOrdersHistory();
                          },
                          child: Text("refresh".tr),
                        ),
                      ],
                    ),
                  );
                } else {
                  return con.orders.isNotEmpty
                      ? TabBarView(
                          children: [
                            RefreshIndicator(
                              onRefresh: con.refreshOrdersHistory,
                              child: ListView.builder(
                                itemCount: con.orders.where((order) => order.status == "waiting").length,
                                itemBuilder: (context, i) => OrderCard(
                                    order: con.orders.where((order) => order.status == "waiting").toList()[i]),
                              ),
                            ),
                            RefreshIndicator(
                              onRefresh: con.refreshOrdersHistory,
                              child: ListView.builder(
                                itemCount: con.orders.length,
                                itemBuilder: (context, i) => OrderCard(order: con.orders[i]),
                              ),
                            ),
                          ],
                        )
                      : Center(child: Text("no orders".tr, style: kTextStyle20));
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
