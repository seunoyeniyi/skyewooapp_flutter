// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/components/product_card.dart';
import 'package:skyewooapp/components/shimmer_product_card.dart';
import 'package:skyewooapp/components/shimmer_shop.dart';
import 'package:skyewooapp/controllers/products_controller.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/main.dart';
import 'package:skyewooapp/models/category.dart';
import 'package:skyewooapp/models/option.dart';
import 'package:skyewooapp/models/product.dart';
import 'package:skyewooapp/models/tag.dart';
import 'package:skyewooapp/ui/filter_dialog.dart';
import 'package:skyewooapp/ui/product/product_page.dart';

class ShopBody extends StatefulWidget {
  const ShopBody({Key? key})
      : super(key: key); //removed const because of GetX controller

  @override
  State<ShopBody> createState() => _ShopBodyState();
}

class _ShopBodyState extends State<ShopBody> {
  final ProductsController productsController = Get.put(ProductsController());

  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 5.0);

  //FILTER LISTs
  List<Category>? categories;
  List<Tag>? tags;
  List<Option>? colors;
  RangeValues? priceRange;
  //INDEX
  int? selectedCatIndex;
  int? selectedTagIndex;
  int? selectedColorIndex;

  // Initial Selected Value
  int sortIndex = 0;

  // List of items in our dropdown menu
  List<ProductSort> sortItems = [
    ProductSort(name: "title menu_order", title: 'Default sorting'),
    ProductSort(name: "popularity", title: 'Sort by popularity'),
    ProductSort(name: "rating", title: 'Sort by average rating'),
    ProductSort(name: "date", title: 'Sort by latest'),
    ProductSort(name: "price", title: 'Sort by price: low to high'),
    ProductSort(name: "price-desc", title: 'Sort by price: high to low'),
  ];

  init() async {
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 180) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Material(
            //HEADER FILTER
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.all(0),
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.f1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<ProductSort>(
                        isExpanded: true,
                        value: sortItems[sortIndex],
                        icon: const Icon(Icons.arrow_drop_down),
                        items: sortItems.map((ProductSort item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sortIndex = sortItems.indexOf(value!);
                            productsController.order_by = value.getName;
                            productsController.fetchProducts(append: false);
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  // SEARCH ICON BUTTON
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          MyHomePage.showSearchBar(context);
                        },
                      ),
                    ),
                  ),
                  // FILTER ICON BUTTON
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FilterDialog(
                                    categories: categories,
                                    tags: tags,
                                    colors: colors,
                                    priceRange: priceRange,
                                    selectedCatIndex: selectedCatIndex,
                                    selectedColorIndex: selectedColorIndex,
                                    selectedTagIndex: selectedTagIndex,
                                    selected_category:
                                        productsController.selected_category,
                                    selected_color:
                                        productsController.selected_color,
                                    selected_tag:
                                        productsController.selected_tag,
                                  );
                                }).then(filterResult);
                          },
                          icon: const Icon(
                            Icons.tune,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Obx(() {
                //message report
                for (var message in productsController.messages) {
                  Toaster.show(message: message);
                }
                //end message report

                if (productsController.isLoading.value &&
                    productsController.products.isEmpty) {
                  return ShopShimmer(
                    itemWidth: itemWidth,
                    itemHeight: itemHeight,
                  );
                } else {
                  return productsLayout(itemWidth, itemHeight);
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget productsLayout(double itemWidth, double itemHeight) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (itemWidth / itemHeight),
            children:
                List.generate(productsController.products.length, (index) {
              double regularPrice = (isNumeric(
                      productsController.products[index].getRegularPrice))
                  ? double.parse(
                      productsController.products[index].getRegularPrice)
                  : 0;
              double price =
                  double.parse(productsController.products[index].getPrice);

              double discount = regularPrice - price;

              return ProductCard(
                userSession: productsController.userSession.value,
                productID: productsController.products[index].getID,
                productTitle: productsController.products[index].getName,
                image: productsController.products[index].getImage,
                regularPrice:
                    productsController.products[index].getRegularPrice,
                price: productsController.products[index].getPrice,
                inWishlist: (productsController.products[index].getInWishList ==
                    "true"),
                discountValue: (discount > 0) ? discount.toString() : "0",
                onPressed: ({bool? inWishlist}) {
                  //product
                  Product product = productsController.products[index];
                  //if wishlist was updated
                  if (inWishlist != null) {
                    product.setInWishList = inWishlist.toString();
                  }
                  //push
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(product: product),
                    ),
                  ).then((dynamic result) {
                    //refresh necessary UIs
                    MyHomePage.resetAppBar(context);
                  });
                },
              );
            }),
          ),
          //LOADING MORE DATA PLACE HOLDER
          (productsController.isLoading.value &&
                  productsController.products.isNotEmpty)
              ? loadingMoreShimmerPlaceholder(itemWidth, itemHeight)
              : const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget loadingMoreShimmerPlaceholder(double itemWidth, double itemHeight) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: (itemWidth / itemHeight),
      children: List.generate(4, (index) {
        return const ShimmerProductCard();
      }),
    );
  }

  _scrollListener() {
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent - 500) &&
        !_scrollController.position.outOfRange &&
        !productsController.isLoading.value &&
        !productsController.gotToEnd.value) {
      if (!productsController.isLoading.value) {
        productsController.currentPaged = productsController.currentPaged + 1;
        productsController.paged = productsController.currentPaged.toString();
        productsController.fetchProducts();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  filterResult(dynamic result) {
    if (result != null) {
      if (result is Map) {
        categories = result["categories"];
        tags = result["tags"];
        colors = result["colors"];
        priceRange = result["price_range"];

        selectedCatIndex = result["selected_cat_index"];
        selectedTagIndex = result["selected_tag_index"];
        selectedColorIndex = result["selected_color_index"];

        productsController.selected_category = result["selected_category"];
        productsController.selected_tag = result["selected_tag"];
        productsController.selected_color = result["selected_color"];
        productsController.priceRange = result["price_range"];
        productsController.fetchProducts(append: false);
      }
    }
  }
}

class ProductSort {
  String name;
  String title;

  ProductSort({required this.name, required this.title});

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getTitle => title;

  set setTitle(title) => this.title = title;
}
