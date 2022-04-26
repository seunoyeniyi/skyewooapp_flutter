import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/site.dart';
import 'package:skyewooapp/ui/search/search_delegate.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppBar({Key? key, this.preferredSize = const Size.fromHeight(56.0)})
      : super(key: key);

  @override
  final Size preferredSize;

  static void updateCartCount(BuildContext context, String count) {
    context.findAncestorStateOfType<_AppAppBarState>()!.updateCartCount(count);
  }

  @override
  State<AppAppBar> createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  UserSession userSession = UserSession();
  String cartCount = "0";
  bool showCartCount = false;

  init() async {
    await userSession.init();
    cartCount = userSession.last_cart_count;
    showCartCount = (int.parse(cartCount) > 0);
    setState(() {});
    if (userSession.logged()) {
      fetchCart();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Image.asset(
        'assets/images/logo-wow.png',
        fit: BoxFit.contain,
        height: 40,
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              "assets/icons/icons8_align_left.svg",
              height: 30,
              width: 30,
            ),
          );
        },
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/icons8_heart_outline.svg",
            height: 25,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Badge(
            showBadge: showCartCount,
            padding: const EdgeInsets.all(5),
            badgeContent: Text(
              cartCount,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeColor: AppColors.primary,
            child: SvgPicture.asset(
              "assets/icons/icons8_shopping_bag.svg",
              height: 25,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: () {},
              child: IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: AppBarSearchDelegate());
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/icons8_search.svg",
                    height: 25,
                  )),
            )),
      ],
    );
  }

  fetchCart() async {
    String url = Site.CART + userSession.ID + "?token_key=" + Site.TOKEN_KEY;
    Response response = await get(url);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);

        if (body is Map) {
          Map<String, dynamic> json = jsonDecode(response.body);

          if (int.parse(json["contents_count"].toString()) > 0) {
            showCartCount = true;
            cartCount = json["contents_count"].toString();
            userSession.update_last_cart_count(cartCount);
          } else {
            showCartCount = false;
          }
        }
      }
    }
    setState(() {});
  }

  void updateCartCount(String count) {
    setState(() {
      cartCount = count;
      showCartCount = (int.parse(cartCount) > 0);
    });
  }
}
