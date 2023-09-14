import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/models/address_model.dart';
import 'package:test1/models/company_model.dart';
import 'package:test1/models/variant_model1.dart';
import 'package:test1/services/remote_services.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final _getStorage = GetStorage();

  final Map<int, VariantModel1> _cart = {};
  Map<int, VariantModel1> get cart => _cart;

  final Map<int, int> _quantity = {};
  Map<int, int> get quantity => _quantity;

  final Map<int, ProductModel> _parents = {};
  Map<int, ProductModel> get parents => _parents;

  late List<CompanyModel> _companies = [];
  List<CompanyModel> get companies => _companies;

  late List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  late CompanyModel _selectedCompany;
  late AddressModel _selectedAddress;
  AddressModel get selectedAddress => _selectedAddress;

  bool enabled = false;
  bool selected = false;

  void setCompany(CompanyModel company) {
    _selectedCompany = company;
    getAddresses();
  }

  void setAddress(AddressModel address) {
    _selectedAddress = address;
    selected = true;
  }

  bool isLoading = false;

  void setLoading(bool val) {
    isLoading = val;
    update();
  }

  //i used a map instead of a list to not duplicate products after refreshing the fetched list
  //if the user refreshes the list the same products will be fetched but will be stored in different part in memory
  //so the app will see them as a different products
  //by using a map and link every product to its unique id we can avoid this problem
  //and i used a second map to store the amount of each product in the cart in the same way
  //the cart and quantity are stored in the device's local storage
  //on every modification on the cart or the quantity we store the values in local storage
  //in the keys "cart" and "cart quantity" to restore them later by using the method loadCartFromLocalStorage();
  //the method loadCartFromLocalStorage(); will be called on every CartController() initialization

  @override
  void onInit() {
    super.onInit();
    loadCartFromLocalStorage();
    getCompanies();
    // todo: make a request to update variants quantities , on init and on list refresh
  }

  void addToCart(VariantModel1 variant, ProductModel product) {
    if (_quantity.containsKey(variant.id)) {
      increaseVariantCount(variant);
    } else {
      _cart[variant.id] = variant;
      variant.quantity == 0 ? _quantity[variant.id] = 1 : _quantity[variant.id] = 1;
      _parents[variant.id] = product;
    }
    // print(variant.id);
    // print(product.id);
    update();
    saveCartInLocalStorage();
  }

  void removeFromCart(VariantModel1 variant) {
    _parents.remove(variant.id); //todo: test this (if parents map get deleted without errors)
    _cart.remove(variant.id);
    _quantity.remove(variant.id);
    update();
    saveCartInLocalStorage();
  }

  void clearCart() {
    _cart.clear();
    _quantity.clear();
    _parents.clear();
    update();
    saveCartInLocalStorage();
  }

  void increaseVariantCount(VariantModel1 variant) {
    if (_quantity[variant.id]! < variant.quantity) {
      _quantity[variant.id] = (_quantity[variant.id]! + 1);
      update();
      saveCartInLocalStorage();
    }
  }

  void decreaseVariantCount(VariantModel1 variant) {
    if (_quantity[variant.id]! > 1) {
      _quantity[variant.id] = (_quantity[variant.id]! - 1);
      update();
      saveCartInLocalStorage();
    }
  }

  void saveCartInLocalStorage() {
    List<VariantModel1> cartAsList = _cart.values.toList();
    List<int> countAsList = _quantity.values.toList();
    List<ProductModel> parentsAsList = _parents.values.toList();
    _getStorage.write("cart", variantModel1ToJson(cartAsList));
    _getStorage.write("parents", productModelToJson(parentsAsList));
    _getStorage.write("cart quantity", jsonEncode(countAsList));
  }

  void loadCartFromLocalStorage() {
    if (_getStorage.read("cart") != null && _getStorage.read("parents") != null) {
      List<VariantModel1> cartAsList = variantModel1FromJson(_getStorage.read("cart"));
      List<ProductModel> parentsAsList = productModelFromJson(_getStorage.read("parents"));
      List countAsList = jsonDecode(_getStorage.read("cart quantity"));
      for (int i = 0; i < cartAsList.length; i++) {
        _cart[cartAsList[i].id] = cartAsList[i];
        _quantity[cartAsList[i].id] = countAsList[i];
      }
      for (int i = 0; i < parentsAsList.length; i++) {
        _parents[cartAsList[i].id] = parentsAsList[i];
      }
      //todo: update variant quantity
    }
  }

  Future<void> getCompanies() async {
    try {
      _companies = (await RemoteServices.fetchShippingCompanies())!;
    } catch (e) {
      //
    } finally {
      //
    }
  }

  Future<void> getAddresses() async {
    try {
      enabled = false;
      _addresses = (await RemoteServices.fetchCompanyAddresses(_selectedCompany.id))!;
      enabled = true;
      update();
    } catch (e) {
      //
    } finally {
      //
    }
  }

  Future<void> makeOrder() async {
    setLoading(true);
    List<Map<String, int>> orders = _quantity.entries.map((entry) {
      return {"inventory_id": entry.key, "quantity": entry.value};
    }).toList();
    try {
      RemoteServices.createOrder(orders, _selectedAddress.id, _getStorage.read("token"));
      //show dialog if quantity is right
    } catch (e) {
      //
    } finally {
      setLoading(false);
    }
    // print(orders);
    // print("totalprice: $totalPrice");
    // print("addressId: ${_selectedAddress.id}");
  }

  Future<void> updateQuantity() async {
    //todo loop over the response
    //todo update quantity
    update();
  }

  double get totalPrice {
    double sum = 0;
    for (VariantModel1 variant in _cart.values) {
      double unitPrice = (((variant.price == 0 ? _parents[variant.id]!.price : variant.price) -
                  (variant.price * (_parents[variant.id]!.offer.value ?? 0) / 100)) *
              _quantity[variant.id]!)
          .toDouble();
      sum += unitPrice;
    }
    return sum;
  }

  int get totalProductsAmount {
    int sum = 0;
    for (VariantModel1 variant in _cart.values) {
      sum += _quantity[variant.id]!;
    }
    return sum;
  }
}
