import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/models/order_model.dart';

import '../models/address_model.dart';
import '../models/company_model.dart';
import '../models/variant_model2.dart';
import '../services/remote_services.dart';

class EditOrderController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getCompanies();
    //updateQuantity();
    // for (VariantModel2 variant in order.variants) {
    //   _currentQuantity[variant.id] = variant.quantity;
    // }
  }
  //todo: use spread operator to not change original order

  EditOrderController({required this.order}) {
    //_variants = List.generate(order.variants.length, (i) => order.variants[i]);
    _variants = order.variants;
  }

  final OrderModel order;

  late List<VariantModel2> _variants = [];
  List<VariantModel2> get variants => _variants;

  final List<int> deleted = [];

  late final Map<int, int> _currentQuantity = {};
  Map<int, int> get currentQuantity => _currentQuantity;

  late List<int> _quantity = [];

  final List<Map<String, int>> edited = [];

  late List<CompanyModel> _companies = [];
  List<CompanyModel> get companies => _companies;

  late List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  late CompanyModel _selectedCompany;
  late AddressModel? _selectedAddress;
  AddressModel? get selectedAddress => _selectedAddress;

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

  void delete(VariantModel2 variant) {
    deleted.add(variant.id);
    _variants.remove(variant);
    update();
  }

  // void increase(VariantModel2 variant) {
  //   if (edited.any((map) => map["inventory_id"] == variant.id)) {
  //     for (int i = 0; i < edited.length; i++) {
  //       if (edited[i]["inventory_id"] == variant.id) edited[i]["inventory_id"] = (edited[i]["inventory_id"])! + 1;
  //     }
  //   } else {
  //     edited.add({"inventory_id": variant.id, "quantity": variant.quantity + 1});
  //   }
  //   _currentQuantity[variant.id] = _currentQuantity[variant.id]! + 1;
  //   update();
  // }
  //
  // void decrease(VariantModel2 variant) {
  //   if (variant.quantity > 1) {
  //     if (edited.any((map) => map["inventory_id"] == variant.id)) {
  //       for (int i = 0; i < edited.length; i++) {
  //         if (edited[i]["inventory_id"] == variant.id) (edited[i]["inventory_id"])! - 1;
  //       }
  //     } else {
  //       edited.add({"inventory_id": variant.id, "quantity": variant.quantity - 1});
  //     }
  //     _currentQuantity[variant.id] = _currentQuantity[variant.id]! - 1;
  //     update();
  //   }
  // }

  Future<void> getCompanies() async {
    try {
      _companies = (await RemoteServices.fetchShippingCompanies())!;
    } catch (e) {
      //
    } finally {
      update();
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

  Future<void> updateQuantity() async {
    //todo loop over the response
    //todo update quantity
    //todo make form validator for search drop down
    update();
  }

  Future<void> editOrder() async {
    try {
      int? temp;
      if (_selectedAddress != null) temp = _selectedAddress!.id;
      print(temp);
      print(deleted);
      print(order.id);
      await RemoteServices.editOrder(_getStorage.read("token"), order.id, temp, deleted);
    } catch (e) {
      //
    } finally {
      //
    }
  }
}
