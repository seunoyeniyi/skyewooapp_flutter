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
}
