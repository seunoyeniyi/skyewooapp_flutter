// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/components/product_card.dart';
import 'package:skyewooapp/components/shimmer_shop.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/models/products.dart';
import 'package:skyewooapp/site.dart';

class ShopBody extends StatefulWidget {
  const ShopBody({Key? key}) : super(key: key);

  @override
  State<ShopBody> createState() => _ShopBodyState();
}

class _ShopBodyState extends State<ShopBody> {
  UserSession userSession = UserSession();

  List<Product> products = [];
  String order_by = "title menu_order";
  String paged = "1";
  int currentPaged = 1;
  bool isLoading = true;

  String title = "Shop";

  // Initial Selected Value
  String sortDropdownValue = 'Default sorting';

  // List of items in our dropdown menu
  var sortItems = [
    'Default sorting',
    'Sort by popularity',
    'Sort by average rating',
    'Sort by latest',
    'Sort by price: low to high',
    'Sort by price: high to low',
  ];

  init() async {
    await userSession.init();
    fetchProducts();
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
                      child: DropdownButton(
                        isExpanded: true,
                        value: sortDropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: sortItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            sortDropdownValue = newValue!;
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                          onPressed: () {},
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
              child: (isLoading)
                  ? ShopShimmer(
                      itemWidth: itemWidth,
                      itemHeight: itemHeight,
                    )
                  : productLayout(itemWidth, itemHeight),
            ),
          ),
        ],
      ),
    );
  }

  Widget productLayout(double itemWidth, double itemHeight) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: (itemWidth / itemHeight),
        children: List.generate(products.length, (index) {
          double regularPrice = (isNumeric(products[index].getRegularPrice))
              ? double.parse(products[index].getRegularPrice)
              : 0;
          double price = double.parse(products[index].getPrice);

          double discount = regularPrice - price;

          return ProductCard(
            productTitle: products[index].getName,
            image: products[index].getImage,
            regularPrice: products[index].getRegularPrice,
            price: products[index].getPrice,
            inWishlist: false,
            discountValue: (discount > 0) ? discount.toString() : "0",
          );
        }),
      ),
    );
  }

  fetchProducts() async {
    isLoading = true;
    String url = Site.SIMPLE_PRODUCTS +
        "?orderby=" +
        order_by +
        "?per_page=40&hide_description=1" +
        "&user_id=" +
        userSession.ID +
        "&paged=" +
        paged +
        "&token_key=" +
        Site.TOKEN_KEY;

    Response response = await get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.isNotEmpty) {
        List<Map<String, dynamic>> results = List.from(json["results"]);
        for (var item in results) {
          Product product = Product();
          product.setID = item["ID"].toString();
          product.setName = item["name"].toString();
          product.setImage = item["image"].toString().toString();
          product.setPrice = item["price"].toString();
          product.setRegularPrice = item["regular_price"].toString();
          product.setType = item["type"].toString();
          product.setProductType = item["product_type"].toString();
          product.setDescription = item["description"].toString();
          product.setInWishList = item["in_wishlist"].toString();
          product.setCategories = item["categories"].toString();
          product.setStockStatus = item["stock_status"].toString();
          product.setLowestPrice = item["lowest_variation_price"].toString();
          product.setHighestPrice = item["highest_variation_price"].toString();

          products.add(product);
        }

        if (json.containsKey("pagination")) {
          if (json["pagination"] != null) {
            currentPaged = int.parse(json["paged"]);
          }
        }

        isLoading = false;
      } else {
        Toast.show(context, "Oops.. No result");
      }
    } else {
      Toast.show(context, "Oops.. Error communication", title: "Error");
    }

    //update state after everything
    setState(() {});
  }
}
