import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/order_model.dart';
import 'package:test1/services/remote_services.dart';

class OrdersController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  @override
  void onInit() {
    getOrdersHistory();
    super.onInit();
  }

  //todo: implement pagination
  int _page = 1;

  late List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  bool isLoading = false;
  bool isFetched = false;

  void setLoadingAll(bool val) {
    isLoading = val;
    update();
  }

  void setFetched(bool val) {
    isFetched = val;
    update();
  }

  Future<void> getOrdersHistory() async {
    try {
      setLoadingAll(true);
      _orders = (await RemoteServices.fetchOrdersHistory(_getStorage.read("token")).timeout(kTimeOutDuration2))!;
      print("reach");
      setFetched(true);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      //
    } finally {
      setLoadingAll(false);
      print(_orders);
    }
  }

  Future<void> refreshOrdersHistory() async {
    setLoadingAll(true);
    setFetched(false);
    getOrdersHistory();
  }

  // Future getPendingOrders() async {
  //   try {
  //     setLoadingCurrent(true);
  //     _pending = (await RemoteServices.fetchPendingOrders(_getStorage.read("token")).timeout(kTimeOutDuration2))!;
  //     setFetchedCurrent(true);
  //   } on TimeoutException {
  //     kTimeOutDialog();
  //   } catch (e) {
  //     //
  //   } finally {
  //     setLoadingCurrent(false);
  //   }
  // }
  //
  // Future<void> refreshPendingOrders() async {
  //   setLoadingCurrent(true);
  //   setFetchedCurrent(false);
  //   getPendingOrders();
  // }
}
