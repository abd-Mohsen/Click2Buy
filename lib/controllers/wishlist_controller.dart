import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/wishlist_model.dart';

import '../services/remote_services.dart';

class WishlistController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print(_getStorage.read("token"));
    getProducts();
    // String s = "<p>wanna show of in front of your ex and his wife ? here is the best solution<br/>new line</p>";
    // var doc = parse(s);
    // print(parse(doc.body!.text).documentElement!.text);
  }

  final GetStorage _getStorage = GetStorage();

  late List<WishlistModel> _wishlist;
  List<WishlistModel> get wishlist => _wishlist;

  bool isLoading = true;
  bool isFetched = false;

  void setLoading(bool val) {
    isLoading = val;
    update();
  }

  void setFetched(bool val) {
    isFetched = val;
    update();
  }

  Future<void> getProducts() async {
    try {
      _wishlist = (await RemoteServices.fetchWishlist(_getStorage.read("token")).timeout(kTimeOutDuration2))!;
      setFetched(true);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshProducts() async {
    setLoading(true);
    setFetched(false);
    getProducts();
  }

  Future<void> deleteProduct(WishlistModel wishlistProduct) async {
    try {
      if (await RemoteServices.deleteFromWishlist(_getStorage.read("token"), wishlistProduct.wishListId)
          .timeout(kTimeOutDuration3)) {
        wishlist.remove(wishlistProduct);
        update();
      }
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      //
    } finally {
      //
    }
  }
}
