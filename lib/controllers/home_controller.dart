import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/banner_model.dart';
import 'package:test1/models/category_model.dart';
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
    getParentsCategories();
    getAllRows();
    getBanners();
    if (_getStorage.hasData("token")) getCurrentUser();
  }

  @override
  void onClose() {
    super.onClose();
    pusher.disconnect();
    navigateController.dispose();
  }

  //--------------------------------------------------------------------------------
  //for fetching product rows in home from server
  late List<ProductRowModel> _rowsList;
  List<ProductRowModel> get rowsList => _rowsList;

  bool _isLoadingRows = true;
  bool get isLoadingRows => _isLoadingRows;
  void setLoadingRows(bool value) {
    _isLoadingRows = value;
    update();
  }

  bool _isFetchedRows = false;
  bool get isFetchedRows => _isFetchedRows;
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
      //
    } finally {
      setLoadingRows(false);
    }
  }

  Future refreshHome() async {
    setFetchedRows(false);
    setFetchedBanners(false);
    setLoadingBanners(true);
    setLoadingRows(true);
    getAllRows();
    getBanners();
  }

  //--------------------------------------------------------------------------------
  //for fetching current user from server
  late List<UserModel> _currentUser;
  List<UserModel> get currentUser => _currentUser;

  bool _isLoadingUser = true;
  bool get isLoadingUser => _isLoadingUser;
  void setLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  bool _isFetchedUser = false;
  bool get isFetchedUser => _isFetchedUser;
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
  void setLoadingCategories(bool value) {
    _isLoadingCategories = value;
    update();
  }

  bool _isFetchedCat = false;
  bool get isFetchedCat => _isFetchedCat;
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
      //
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

  late List<BannerModel> banners = [];

  bool _isLoadingBanners = false;
  bool get isLoadingBanners => _isLoadingBanners;
  void setLoadingBanners(bool value) {
    _isLoadingBanners = value;
    update();
  }

  bool _isFetchedBanners = false;
  bool get isFetchedBanners => _isFetchedBanners;
  void setFetchedBanners(bool value) {
    _isFetchedBanners = value;
    update();
  }

  void getBanners() async {
    try {
      setLoadingBanners(true);
      banners = (await RemoteServices.fetchBanners().timeout(kTimeOutDuration2))!;
      setFetchedBanners(true);
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      //
    } finally {
      setLoadingBanners(false);
    }
  }

  //--------------------------------------------------------------------------------
  //for bottom bar navigation

  int _selectedIndex = 1; // initial scaffold body index (home tab)
  int get selectedIndex => _selectedIndex;
  PageController navigateController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void changeTabFromPage(int index) {
    _selectedIndex = index;
    navigateController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    update();
  }

  void changeTabFromBar(int index) {
    _selectedIndex = index;
    navigateController.jumpToPage(
      index,
    );
    update();
  }

  //---------------------------------------------------------------------------------
  //for edit profile
  bool _isLoadingConfirmPassword = false;
  bool get isLoadingConfirmPassword => _isLoadingConfirmPassword;
  void setLoadingConfirm(bool value) {
    _isLoadingConfirmPassword = value;
    update();
  }

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

  //---------------------------------------------------------------------------------
  //for pusher
  PusherClient pusher = PusherClient("6d8a30fe15f00eb58c79", PusherOptions(cluster: "eu"));

  Future initPusher() async {
    pusher.connect();
    Channel channel = pusher.subscribe("abd_channel");

    channel.bind("public-noti", (event) {
      String msg = event!.data!;
      print((jsonDecode(msg))["title"]);
      //NotificationService.showNotification(title: message["jbb"], body: "this is a notification");
    });
    // pusher.onConnectionError((error) {
    //   print("error: ${error!.message}");
    // });
    // pusher.onConnectionStateChange((state) {
    //   print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    // });
  }

  //--------------------------------------------------------------------------------
}
