import 'package:get/get.dart';
import 'package:test1/models/order_model.dart';
import 'package:test1/models/variant_model.dart';

import '../models/address_model.dart';
import '../models/company_model.dart';
import '../services/remote_services.dart';

class EditOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }

  EditOrderController({required this.order}) {
    _variants = order.variants;
  }

  final OrderModel order;

  late List<VariantModel> _variants = [];
  List<VariantModel> get variants => _variants;

  final List<int> deleted = [];

  final List<Map<String, int>> edited = [];

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

  // void delete(VariantModel variant) {
  //   deleted.add(variant.id);
  //   _variants.remove(variant);
  // }
  //
  // void increase(VariantModel variant) {
  //   if (edited.any((map) => map["inventory_id"] == variant.id)) {
  //     for (int i = 0; i < edited.length; i++) {
  //       if (edited[i]["inventory_id"] == variant.id) {
  //         edited[i]["inventory_id"] = 5;
  //       }
  //     }
  //   } else {
  //     edited.add({"inventory_id": variant.id, "quantity": variant.quantity! + 1});
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
    update();
  }
}
