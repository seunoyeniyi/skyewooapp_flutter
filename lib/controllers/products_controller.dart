// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/models/products.dart';
import 'package:skyewooapp/site.dart';

class ProductsController extends GetxController {
  var userSession = UserSession().obs;
  var isLoading = true.obs;
  var products = <Product>[].obs;
  var messages = <String>[].obs;
  String order_by = "title menu_order";
  String paged = "1";
  int currentPaged = 1;
  String numPerPage = "40";

  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() async {
    await userSession.value.init();
    fetchProducts();
  }

  void fetchProducts({bool append = true}) async {
    try {
      isLoading(true);
      messages.clear(); //clear messages first;
      if (append == false) {
        //clear products, paged, currentPaged and add new
        products.clear();
        paged = "1";
        currentPaged = 1;
      }

      String url = Site.SIMPLE_PRODUCTS +
          "?orderby=" +
          order_by +
          "&per_page=" +
          numPerPage +
          "&hide_description=1" +
          "&user_id=" +
          userSession.value.ID +
          "&paged=" +
          paged +
          "&token_key=" +
          Site.TOKEN_KEY;

      switch (order_by) {
        case "price":
          url = Site.SIMPLE_PRODUCTS +
              "?orderby=meta_value_num&meta_key=_price&order=asc&per_page=" +
              numPerPage +
              "&hide_description=1" +
              "&user_id=" +
              userSession.value.ID +
              "&paged=" +
              paged +
              "&token_key=" +
              Site.TOKEN_KEY;
          break;
        case "price-desc":
          url = Site.SIMPLE_PRODUCTS +
              "?orderby=meta_value_num&meta_key=_price&order=desc&per_page=" +
              numPerPage +
              "&hide_description=1" +
              "&user_id=" +
              userSession.value.ID +
              "&paged=" +
              paged +
              "&token_key=" +
              Site.TOKEN_KEY;
          break;
        case "date":
          url = Site.SIMPLE_PRODUCTS +
              "?orderby=date&order=DESC&per_page=" +
              numPerPage +
              "&hide_description=1" +
              "&user_id=" +
              userSession.value.ID +
              "&paged=" +
              paged +
              "&token_key=" +
              Site.TOKEN_KEY;
          break;
        default:
          break;
      }

      Response response = await get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> json =
            jsonDecode(response.body.isEmpty ? "{}" : response.body);
        if (json.isNotEmpty) {
          List<Map<String, dynamic>> results = List.from(json["results"]);

          if (append == false && results.isEmpty) {
            messages.add("No Result");
            // Toast.show(context, "No Result", title: "No Products");
          }

          for (var item in results) {
            // log("image: " + item["image"].toString());
            Product product = Product();
            product.setID = item["ID"].toString();
            product.setName = item["name"].toString();
            product.setImage = item["image"].toString();
            product.setPrice = item["price"].toString();
            product.setRegularPrice = item["regular_price"].toString();
            product.setType = item["type"].toString();
            product.setProductType = item["product_type"].toString();
            product.setDescription = item["description"].toString();
            product.setInWishList = item["in_wishlist"].toString();
            product.setCategories = item["categories"].toString();
            product.setStockStatus = item["stock_status"].toString();
            product.setLowestPrice = item["lowest_variation_price"].toString();
            product.setHighestPrice =
                item["highest_variation_price"].toString();

            products.add(product);
          }

          if (json.containsKey("pagination")) {
            if (json["pagination"] != null) {
              currentPaged = int.parse(json["paged"]);
            }
          }
        } else {
          if (products.isEmpty) {
            messages.add("No result");
            // Toast.show(context, "No result", title: "Oops");
          } else {
            // Toast.show(
            //   context,
            //   "No more result",
            //   title: "Oops",
            //   position: FlushbarPosition.BOTTOM,
            //   duration: 4,
            // );
            messages.add("No more result");
          }
        }
      } else {
        messages.add("Oops.. Error communication");
        // Toast.show(context, "Oops.. Error communication", title: "Error");
      }
    } finally {
      isLoading(false);
    }
  }
}
