import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/cart.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/ui/search/search_delegate.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppBar({
    Key? key,
    this.preferredSize = const Size.fromHeight(56.0),
    required this.controller,
  }) : super(key: key);

  final AppAppBarController controller;

  @override
  final Size preferredSize;

  @override
  State<AppAppBar> createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  UserSession userSession = UserSession();
  String cartCount = "0";
  bool showCartCount = false;
  bool showWishlistBadge = false;

  init() async {
    refreshAll();
  }

  refreshAll() async {
    await userSession.init();
    cartCount = userSession.last_cart_count;
    showCartCount = (int.parse(cartCount) > 0);
    setState(() {});
    if (userSession.logged()) {
      fetchCart();
      showWishlistBadge = (int.parse(userSession.last_wishlist_count) > 0);
    }
  }

  @override
  void initState() {
    //apply controllers
    widget.controller.updateWishlistBadge = updateWishlistBadge;
    widget.controller.updateCartCount = updateCartCount;
    widget.controller.displaySearch = displaySearch;
    widget.controller.refreshAll = refreshAll;

    init();
    super.initState();
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
          icon: Badge(
            position: BadgePosition.topEnd(top: -8, end: -4),
            showBadge: showWishlistBadge,
            padding: const EdgeInsets.all(7),
            badgeContent: const Text(
              "",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeColor: Colors.red,
            child: SvgPicture.asset(
              (showWishlistBadge)
                  ? "assets/icons/icons8_heart.svg"
                  : "assets/icons/icons8_heart_outline.svg",
              height: 25,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Badge(
            position: BadgePosition.topEnd(top: -8, end: -4),
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

  void displaySearch() {
    showSearch(context: context, delegate: AppBarSearchDelegate());
  }

  fetchCart() async {
    Cart cart = Cart(userSession: userSession);
    cartCount = await cart.fetchCount();
    if (int.parse(cartCount) > 0) {
      showCartCount = true;
      userSession.update_last_cart_count(cartCount);
    } else {
      showCartCount = false;
    }
    setState(() {});
  }

  void updateCartCount(String count) {
    setState(() {
      cartCount = count;
      showCartCount = (int.parse(cartCount) > 0);
    });
  }

  void updateWishlistBadge(String count) {
    setState(() {
      showWishlistBadge = (int.parse(count) > 0);
    });
  }
}

class AppAppBarController {
  void Function(String)? updateWishlistBadge;
  void Function(String)? updateCartCount;
  void Function()? displaySearch;
  void Function()? refreshAll;
}
