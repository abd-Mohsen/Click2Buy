import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:test1/constants.dart';
import 'package:test1/models/address_model.dart';
import 'package:test1/models/category_model.dart';
import 'package:test1/models/company_model.dart';
import 'package:test1/models/filter_model.dart';
import 'package:test1/models/order_model.dart';
import 'package:test1/models/product_model.dart';
import 'package:test1/models/product_row_model.dart';
import 'package:test1/models/reset_password_model.dart';
import 'package:test1/models/sub_cat_model.dart';
import 'package:test1/models/user_model.dart';
import 'package:test1/models/wishlist_model.dart';
import '../views/login_page.dart';

//https://fakestoreapi.com/products
//https://api.escuelajs.co/api/v1/products
// 10.0.2.2
// 192.168.1.38

//todo: make all get storage token reads from here, not controllers
class RemoteServices {
  static const String _hostIP = "http://10.0.2.2:8000/api";
  static final GetStorage _getStorage = GetStorage();

  static var client = http.Client();
  //static var client2 = http.Client();

  static Future<List<ProductModel>?> fetchAllProducts() async {
    var response = await client.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return productModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<WishlistModel>?> fetchWishlist(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/show_wish_list"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return wishlistModelFromJson(response.body);
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return null;
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> addToWishlist(String token, int id) async {
    var response = await client.post(
      Uri.parse("$_hostIP/add_wish_list/$id"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> deleteFromWishlist(String token, int id) async {
    var response = await client.delete(
      Uri.parse("$_hostIP/delete_wish_list/$id"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<List<ProductRowModel>?> fetchProductRows() async {
    var response = await client.get(Uri.parse("$_hostIP/row_product"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return productRowModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error".tr, middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<CategoryModel>?> fetchParentsCategories() async {
    var response = await client.get(
      Uri.parse("$_hostIP/getcategory"),
      headers: {'Connection': 'keep-alive'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return categoryModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error".tr, middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<SubCategoryModel?> fetchSubCategories(int catId, int page) async {
    var response = await client.get(
      Uri.parse("$_hostIP/productcategory/$catId?page=$page"),
      headers: {'Connection': 'keep-alive'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return subCategoryModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error".tr, middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> createOrder(List<Map<String, int>> orders, int id, String token) async {
    var response = await client.post(
      Uri.parse("$_hostIP/add_order"),
      body: jsonEncode({
        "orders": orders,
        //"total_price": total.toString(),
        "delivery_company_address_id": id.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        'Authorization': "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      Get.defaultDialog(title: "success".tr, middleText: "order added".tr);
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<String?> signUp(String email, String password, String name, String phone) async {
    var response = await client.post(
      Uri.parse("$_hostIP/register"),
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone_number": phone,
        "password": password,
        "password_confirmation": password,
      }),
      headers: {'Content-Type': 'application/json', "Accept": 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["access_token"];
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<String?> sendRegisterOtp(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/email/send-otp-code"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["url"];
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> verifyRegisterOtp(String apiUrl, String token, String otp) async {
    var response = await client.post(
      Uri.parse(apiUrl),
      body: jsonEncode({"otp_code": otp}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> sendForgotPasswordOtp(String email) async {
    var response = await client.get(
      Uri.parse("$_hostIP/forgot-password/$email"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<ResetPassModel?> verifyForgotPasswordOtp(String email, String otp) async {
    var response = await client.post(
      Uri.parse("$_hostIP/forgot-password/check-OTP"),
      body: jsonEncode({"email": email, "code": otp}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResetPassModel.fromJson(jsonDecode(response.body));
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> resetPassword(String email, String password, String resetToken) async {
    var response = await client.post(
      Uri.parse("$_hostIP/forgot-password/reset"),
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": password,
        "token": resetToken,
      }),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<String?> signUserIn(String email, String password) async {
    var response = await client.post(
      Uri.parse("$_hostIP/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {'Content-Type': 'application/json', "Accept": 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["AccessToken"];
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<List<UserModel>?> fetchCurrentUser(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/profile"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return userModelFromJson(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return null;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["error"]);
      return null;
    }
  }

  static Future<bool> signOut(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/logout"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      //kSessionExpiredDialog();
      return true;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> editProfile(String name, String phone, String token) async {
    var response = await client.post(
      Uri.parse("$_hostIP/edit_name_phone"),
      body: jsonEncode({
        "name": name,
        "phone_number": phone,
      }),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> changePassword(String oldPass, String newPass, String token) async {
    var response = await client.post(
      Uri.parse("$_hostIP/edit_password"),
      body: jsonEncode({"old_password": oldPass, "new_password": newPass}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> confirmPassword(String pass, String token) async {
    var response = await client.post(
      Uri.parse("$_hostIP/check_password"),
      body: jsonEncode({"password": pass}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(seconds: 2));
      kSessionExpiredDialog(); //todo: dialog not showing
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<List<CompanyModel>?> fetchShippingCompanies() async {
    var response = await client.get(
      Uri.parse("$_hostIP/deliveryCompany"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return companyModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<AddressModel>?> fetchCompanyAddresses(int companyId) async {
    var response = await client.get(
      Uri.parse("$_hostIP/deliveryCompanyaddress/$companyId"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return addressModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<OrderModel>?> fetchOrdersHistory(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/order_user"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return orderModelFromJson(response.body);
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return null;
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<OrderModel>?> fetchPendingOrders(String token) async {
    var response = await client.get(
      Uri.parse("$_hostIP/"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return orderModelFromJson(response.body);
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return null;
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<FilterModel?> fetchFilters() async {
    var response = await client.get(Uri.parse("$_hostIP/filter_elements"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return filterModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<List<ProductModel>?> search(
      String? brand, String? color, String? material, String? size, String query) async {
    var response = await client.get(Uri.parse(
      "$_hostIP/search_filter?brand=$brand&colour=$color&material=$material&category=null&text=$query&size=$size",
    ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return productModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> addOpinion(String token, int id, String rate, String comment) async {
    var response = await client.post(
        Uri.parse(
          "$_hostIP/add_edit_comment_evaluation/$id",
        ),
        headers: {
          //'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer $token",
        },
        body: {
          "text": comment,
          "evaluation": rate,
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> editOrder(String token, int id, String rate, String comment) async {
    var response = await client.post(
        Uri.parse(
          "$_hostIP/add_edit_comment_evaluation/$id",
        ),
        headers: {
          //'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer $token",
        },
        body: {
          "text": comment,
          "evaluation": rate,
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAll(LoginPage());
      _getStorage.remove("token");
      Future.delayed(const Duration(milliseconds: 200));
      kSessionExpiredDialog();
      return false;
    } else {
      Get.defaultDialog(title: "error".tr, middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }
}
