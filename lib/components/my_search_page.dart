import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/components/custom/abd_icons_icons.dart';
import 'package:test1/components/search_card.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/search_controller.dart';

import '../controllers/product_controller.dart';
import '../views/product_view.dart';

//todo: i get "so many requests" when typing fast
typedef SearchFilter<T> = List<String?> Function(T t);
typedef ResultBuilder<T> = Widget Function(T t);
typedef SortCallback<T> = int Function(T a, T b);

class MySearchPage<T> extends SearchDelegate<T?> {
  final bool showItemsOnEmpty;
  final String? searchLabel;
  final ThemeData? barTheme;
  final bool itemStartsWith;
  final bool itemEndsWith;
  final ValueChanged<String>? onQueryUpdate;
  final TextStyle? searchStyle;

  MySearchPage({
    this.showItemsOnEmpty = false,
    this.searchLabel,
    this.barTheme,
    this.itemStartsWith = false,
    this.itemEndsWith = false,
    this.onQueryUpdate,
    this.searchStyle,
  }) : super(searchFieldLabel: searchLabel, searchFieldStyle: searchStyle);
  MySearchController sC = Get.put(MySearchController());

  @override
  ThemeData appBarTheme(BuildContext context) {
    return barTheme ??
        Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return [
      IconButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 100));
          if (sC.filters != null) {
            //if filters are loaded
            Get.bottomSheet(
              BottomSheet(
                enableDrag: false,
                onClosing: () {
                  sC.searchRequest(query);
                },
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => GetBuilder<MySearchController>(
                  builder: (con) => Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            "filters".tr,
                            style: kTextStyle24Bold,
                            textAlign: TextAlign.center,
                          ),
                          const Divider()
                        ],
                      ),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.monetization_on,
                                  color: cs.onBackground,
                                ),
                                title: Text("price".tr),
                                subtitle: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbColor: cs.primary,
                                    rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6.5),
                                    trackHeight: 0.5,
                                  ),
                                  child: RangeSlider(
                                    values: RangeValues(con.startPrice, con.endPrice),
                                    labels: RangeLabels(
                                      "${con.startPrice.toString()}\$",
                                      "${con.endPrice.toString()}\$",
                                    ),
                                    min: 0.0,
                                    max: 1000,
                                    divisions: 100,
                                    onChanged: (rangeValues) {
                                      con.changePriceSlider(rangeValues);
                                    },
                                  ),
                                ),
                              ),
                              // ListTile(
                              //   leading: Icon(
                              //     Icons.star,
                              //     color: cs.onBackground,
                              //   ),
                              //   title: Text("rating".tr),
                              //   subtitle: SliderTheme(
                              //     data: SliderTheme.of(context).copyWith(
                              //       thumbColor: cs.primary,
                              //       rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6.5),
                              //       trackHeight: 0.5,
                              //     ),
                              //     child: RangeSlider(
                              //       values: RangeValues(con.startRating, con.endRating),
                              //       labels: RangeLabels(
                              //         con.startRating.round().toString(),
                              //         con.endRating.round().toString(),
                              //       ),
                              //       min: 0,
                              //       max: 5,
                              //       divisions: 5,
                              //       onChanged: (rangeValues) {
                              //         con.changeRateSlider(rangeValues);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        hintText: "search".tr,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(Icons.search, color: cs.onSurface),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "brand".tr,
                                      hintText: "choose a brand".tr,
                                      labelStyle: kTextStyle18,
                                      icon: const Icon(AbdIcons.tag),
                                    ),
                                  ),
                                  items: con.filters!.brand.map((e) => e.name).toList(),
                                  onChanged: (String? brand) {
                                    con.brand = brand;
                                  },
                                  enabled: true,
                                  validator: (String? a) {
                                    if (a == null) {
                                      return "Required field".tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        hintText: "search".tr,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(Icons.search, color: cs.onSurface),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "color".tr,
                                      hintText: "choose a color".tr,
                                      labelStyle: kTextStyle18,
                                      icon: const Icon(Icons.color_lens),
                                    ),
                                  ),
                                  items: con.filters!.colour.map((e) => e.name).toList(),
                                  onChanged: (String? c) {
                                    con.color = c;
                                  },
                                  enabled: true,
                                  validator: (String? a) {
                                    if (a == null) {
                                      return "Required field".tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        hintText: "search".tr,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(Icons.search, color: cs.onSurface),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "size".tr,
                                      hintText: "choose a size".tr,
                                      labelStyle: kTextStyle18,
                                      icon: const Icon(Icons.format_size),
                                    ),
                                  ),
                                  items: con.filters!.size.map((e) => e.size).toList(),
                                  onChanged: (String? s) {
                                    con.size = s;
                                  },
                                  enabled: true,
                                  validator: (String? a) {
                                    if (a == null) {
                                      return "Required field".tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        hintText: "search".tr,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(Icons.search, color: cs.onSurface),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "material".tr,
                                      hintText: "choose a material".tr,
                                      labelStyle: kTextStyle18,
                                      icon: const Icon(Icons.cases_sharp),
                                    ),
                                  ),
                                  items: con.filters!.material.map((e) => e.name).toList(),
                                  onChanged: (String? m) {
                                    con.material = m;
                                  },
                                  enabled: true,
                                  validator: (String? a) {
                                    if (a == null) {
                                      return "Required field".tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  con.clearFilters();
                                },
                                child: Text("clear filters".tr, style: kTextStyle18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        icon: const Icon(AbdIcons.filter),
      ),
      AnimatedOpacity(
        opacity: query.isNotEmpty ? 1.0 : 0.0,
        duration: kThemeAnimationDuration,
        curve: Curves.easeInOutCubic,
        child: IconButton(
          tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () => Get.back(),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    sC.searchRequest(query);
    final cleanQuery = query.toLowerCase().trim();
    Widget suggestion = GetBuilder<MySearchController>(builder: (cont) {
      return cont.searchHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 100, color: cs.onBackground),
                  Text(
                    'No history yet'.tr,
                    style: kTextStyle24.copyWith(color: cs.onBackground),
                  ),
                ],
              ),
            )
          : ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: cont.searchHistory.length,
              itemBuilder: (context, i) {
                final product = cont.searchHistory.entries.elementAt(i).value;
                return ListTile(
                  onTap: () {
                    Get.put(ProductController(product: product));
                    Get.to(ProductView(product: product, heroTag: ""));
                    cont.addToHistory(product);
                  },
                  leading: const Icon(Icons.history),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    style: kTextStyle14.copyWith(overflow: TextOverflow.ellipsis),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      cont.removeFromHistory(product);
                    },
                  ),
                );
              },
            );
    });
    Widget failure = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 100, color: cs.onBackground),
          Text(
            'No products found'.tr,
            style: kTextStyle24.copyWith(color: cs.onBackground),
          ),
        ],
      ),
    );

    final result = sC.searchResult.isNotEmpty
        ? sC.searchResult
            .where((product) => product.price <= sC.endPrice && sC.startPrice <= product.price
                // product.rating![0].value! <= sC.endRating &&
                // sC.startPrice <= product.rating![0].value!
                )
            .toList()
        : [];

    return cleanQuery.isEmpty && !showItemsOnEmpty
        ? suggestion
        : result.isEmpty
            ? failure
            : GetBuilder<MySearchController>(
                builder: (con) {
                  if (con.isLoading) {
                    return Center(child: CircularProgressIndicator(color: cs.primary));
                  } else {
                    return ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SearchCard(
                          product: result[i],
                          onPress: () {
                            Get.put(ProductController(product: result[i]));
                            Get.off(ProductView(product: result[i], heroTag: ""));
                            sC.addToHistory(result[i]);
                          },
                        ),
                      ),
                    );
                  }
                },
              );
  }
}
