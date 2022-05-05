import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/site.dart';

class Cart {
  UserSession userSession;

  Cart({required this.userSession});

  Future<String> fetchCount() async {
    String url = Site.CART + userSession.ID + "?token_key=" + Site.TOKEN_KEY;
    Response response = await get(url);

    String itemsCount = "0";

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);

        if (body is Map) {
          Map<String, dynamic> json = jsonDecode(response.body);

          userSession.update_last_cart_count(json["contents_count"].toString());
          itemsCount = json["contents_count"].toString();
        }
      }
    }
    return itemsCount;
  }

  Future<Map<String, dynamic>> addToCart(
      {required String productID,
      required int quantity,
      bool replaceQuantity = false}) async {
    String url = Site.ADD_TO_CART + productID;

    String status = "failed";
    String message = "";
    String contentsCount = "0";
    String subTotal = "0";
    String total = "0";

    dynamic data = {
      "quantity": quantity.toString(),
      "token_key": Site.TOKEN_KEY,
    };
    if (userSession.ID != "0" || userSession.logged()) {
      data["user"] = userSession.ID;
    }

    Response response = await post(url, body: data);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(response.body);

      if (json.containsKey("user_cart_not_exists")) {
        status = "failed";
        message = "Cannot create cart! Please login or register (or logout).";
      } else if (json.containsKey("code") || json.containsKey("msg")) {
        status = "failed";
        message = json["msg"].toString();
      } else {
        //success
        if (userSession.ID == "0" && !json["user_cart_exists"]) {
          //save the generated user id to session
          await userSession.createLoginSession(
            userID: json["user"].toString(),
            xusername: "",
            xemail: "",
            logged: false,
          );
        }

        status = "success";
        contentsCount = json["contents_count"].toString();
        subTotal = json["subtotal"].toString();
        total = json["total"].toString();
        message = "Product added to cart";

        await userSession.update_last_cart_count(contentsCount);
      }

      //else network error, server error, timeout, or any other error
    } else {
      status = "failed";
      message =
          "Unable to update cart! You may need to logout and login again.";
    }

    return {
      "status": status,
      "contents_count": contentsCount,
      "total": total,
      "sub_total": subTotal,
      "message": message,
    };
  }
}
