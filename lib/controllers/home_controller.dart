import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/category_model.dart';
import 'package:test1/models/product_model.dart';
import 'package:test1/models/product_row_model.dart';
import 'package:test1/models/user_model.dart';
import 'package:test1/services/notification_service.dart';
import 'package:pusher_client/pusher_client.dart';
import '../services/remote_services.dart';
import '../views/edit_profile_view.dart';
import '../views/login_page.dart';

class HomeController extends GetxController {
  final _getStorage = GetStorage(); //local storage

  @override
  void onInit() {
    super.onInit();
    initPusher();
    //getAllProductsList();
    getParentsCategories();
    getAllRows();
    if (_getStorage.hasData("token")) getCurrentUser();
    Future.delayed(const Duration(seconds: 1));
    //startAutoScrollingBanners();
  }

  @override
  void onClose() {
    super.onClose();
    // _timer.cancel(); //stop auto scrolling
    pusher.disconnect();
    // pageController.dispose();
    // navigateController.dispose();
  }

  //--------------------------------------------------------------------------------
  //for fetching all products from server
  late List<ProductModel> _productsList;
  List<ProductModel> get productsList => _productsList;
  bool _isLoadingProducts = true;
  bool get isLoadingProducts => _isLoadingProducts;
  bool _isFetchedProducts = false;
  bool get isFetchedProducts => _isFetchedProducts;

  void setLoadingProduct(bool value) {
    _isLoadingProducts = value;
    update();
  }

  void setFetchedProducts(bool value) {
    _isFetchedProducts = value;
    update();
  }

  void getAllProductsList() async {
    try {
      _productsList = (await RemoteServices.fetchAllProducts().timeout(kTimeOutDuration))!;
      setFetchedProducts(true);
    } on TimeoutException {
      setLoadingProduct(false);
    } catch (e) {
      //show different message if it was a server error
    } finally {
      setLoadingProduct(false);
    }
  }

  Future refreshAllProducts() async {
    setFetchedProducts(false);
    setLoadingProduct(true);
    getAllProductsList();
  }

  //--------------------------------------------------------------------------------
  //for fetching product rows in home screen from server
  late List<ProductRowModel> _rowsList;
  List<ProductRowModel> get rowsList => _rowsList;
  bool _isLoadingRows = true;
  bool get isLoadingRows => _isLoadingRows;
  bool _isFetchedRows = false;
  bool get isFetchedRows => _isFetchedRows;

  void setLoadingRows(bool value) {
    _isLoadingRows = value;
    update();
  }

  void setFetchedRows(bool value) {
    _isFetchedRows = value;
    update();
  }

  void getAllRows() async {
    try {
      _rowsList = (await RemoteServices.fetchProductRows().timeout(kTimeOutDuration2))!;
      setFetchedRows(true);
    } on TimeoutException {
      setLoadingRows(false);
    } catch (e) {
      print(e.toString());
      //show different message if it was a server error
    } finally {
      setLoadingRows(false);
    }
  }

  Future refreshAllRows() async {
    setFetchedRows(false);
    setLoadingRows(true);
    getAllRows();
  }

  //--------------------------------------------------------------------------------
  //for fetching current user from server
  late List<UserModel> _currentUser;
  List<UserModel> get currentUser => _currentUser;
  bool _isLoadingUser = true;
  bool get isLoadingUser => _isLoadingUser;

  bool _isFetchedUser = false;
  bool get isFetchedUser => _isFetchedUser;

  void setLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  void setFetchedUser(bool value) {
    _isFetchedUser = value;
    update();
  }

  void getCurrentUser() async {
    try {
      _currentUser = (await RemoteServices.fetchCurrentUser(_getStorage.read("token")).timeout(kTimeOutDuration))!;
      setFetchedUser(true);
    } on TimeoutException {
      setLoadingUser(false);
    } catch (e) {
      //
    } finally {
      setLoadingUser(false);
      print(_currentUser);
    }
  }

  Future refreshUser() async {
    setFetchedUser(false);
    setLoadingUser(true);
    getCurrentUser();
  }

  void logOut() async {
    if (await RemoteServices.signOut(_getStorage.read("token"))) {
      _getStorage.remove("token");
      Get.offAll(() => LoginPage());
    }
  }

  //--------------------------------------------------------------------------------
  //for fetching parent categories from server
  late List<CategoryModel> _categoriesList;
  List<CategoryModel> get categoriesList => _categoriesList;
  bool _isLoadingCategories = true;
  bool get isLoadingCategories => _isLoadingCategories;
  bool _isFetchedCat = false;
  bool get isFetchedCat => _isFetchedCat;

  void setLoadingCategories(bool value) {
    _isLoadingCategories = value;
    update();
  }

  void setFetchedCat(bool value) {
    _isFetchedCat = value;
    update();
  }

  void getParentsCategories() async {
    try {
      _categoriesList = (await RemoteServices.fetchParentsCategories().timeout(kTimeOutDuration))!;
      setFetchedCat(true);
    } on TimeoutException {
      setLoadingCategories(false);
    } catch (e) {
      print(e.toString());
    } finally {
      setLoadingCategories(false);
    }
  }

  Future refreshParentsCategories() async {
    setFetchedCat(false);
    setLoadingCategories(true);
    getParentsCategories();
  }

  //--------------------------------------------------------------------------------
  //for banners auto-scroll
  final List<String> banners = [
    "assets/images/banner-05.png",
    "assets/images/banner-06.png",
    "assets/images/banner-01.jpg",
    "assets/images/banner-02.jpg",
    "assets/images/banner-03.jpg",
  ];

  // int _currentPage = 0;
  // late Timer _timer;
  // final PageController _pageController = PageController(initialPage: 0);
  // PageController get pageController => _pageController;
  //
  // //todo: banners stopped auto scrolling
  // void startAutoScrollingBanners() {
  //   _timer = Timer.periodic(
  //     const Duration(seconds: 4),
  //     (timer) {
  //       if (_currentPage < banners.length) {
  //         _currentPage++;
  //       } else {
  //         _currentPage = 0;
  //       }
  //       if (pageController.hasClients) {
  //         _pageController.animateToPage(
  //           _currentPage,
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeIn,
  //         );
  //       }
  //     },
  //   );
  // }

  //--------------------------------------------------------------------------------
  //for bottom bar navigation

  int _selectedIndex = 1; // initial scaffold body index (home tab)
  int get selectedIndex => _selectedIndex; // getter
  PageController navigateController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void changeTab(int index) {
    _selectedIndex = index;
    navigateController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    update();
  }

  //---------------------------------------------------------------------------------
  //for edit profile
  bool _isLoadingConfirmPassword = false;
  bool get isLoadingConfirmPassword => _isLoadingConfirmPassword;

  GlobalKey<FormState> settingKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  void confirmPassword(String password) async {
    buttonPressed = true;
    if (settingKey.currentState!.validate()) {
      setLoadingConfirm(true);
      try {
        if (await RemoteServices.confirmPassword(password, _getStorage.read("token")).timeout(kTimeOutDuration2)) {
          Get.off(EditProfileView(user: _currentUser[0])); //todo: what if user dismissed the dialog when loading?
        }
      } on TimeoutException {
        Get.showSnackbar(GetSnackBar(
          messageText: Text(
            "check your internet".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey.shade800,
          duration: const Duration(milliseconds: 1000),
          borderRadius: 30,
          maxWidth: 150,
          margin: const EdgeInsets.only(bottom: 50),
        ));
      } catch (e) {
        //
      } finally {
        setLoadingConfirm(false);
      }
    }
  }

  void setLoadingConfirm(bool value) {
    _isLoadingConfirmPassword = value;
    update();
  }

  //---------------------------------------------------------------------------------
  //for pusher
  PusherClient pusher = PusherClient("6d8a30fe15f00eb58c79", PusherOptions(cluster: "eu"));

  Future initPusher() async {
    pusher.connect();
    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });
    Channel channel = pusher.subscribe("abd_channel");

    channel.bind("public-noti", (event) {
      print("hi a");
      NotificationService.showNotification(title: "hi");
      print("hi b");
    });

    // pusher.onConnectionStateChange((state) {
    //   print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    // });
  }

  //--------------------------------------------------------------------------------
}
