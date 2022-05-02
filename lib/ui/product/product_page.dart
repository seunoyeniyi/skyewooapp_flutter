// ignore: import_of_legacy_library_into_null_safe
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/app_styles.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/handlers/wishlist.dart';
import 'package:skyewooapp/models/product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  UserSession userSession = UserSession();

  String cartCount = "0";
  bool showCartCount = false;

  Product product = Product(id: "", name: "");
  bool inWishlist = false;
  bool showSliverTitle = true;

  int _quantity = 1;

  init() async {
    await userSession.init();
    cartCount = userSession.last_cart_count;
    showCartCount = (int.parse(cartCount) > 0);
    setState(() {});
  }

  @override
  void initState() {
    product = widget.product;
    inWishlist = product.getInWishList == "true";

    if (product.getID.isEmpty || product.getID == "0") {
      Toaster.show(message: "No product selected.");
      Navigator.pop(context);
    }

    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 400.0,
              stretch: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  showSliverTitle = (constraints.biggest.height < 120);
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    title: Visibility(
                      visible: showSliverTitle,
                      child: Text(
                        product.getName.length > 18
                            ? product.getName.substring(0, 18) + "..."
                            : product.getName,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        FittedBox(
                          fit: BoxFit.cover,
                          child: (() {
                            if (product.getImage.isNotEmpty &&
                                product.getImage != "false" &&
                                Uri.parse(product.getImage).isAbsolute) {
                              return Container(
                                color: AppColors.f1,
                                child: CachedNetworkImage(
                                  imageUrl: product.getImage,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: AppColors.f1,
                                    highlightColor: Colors.white,
                                    period: const Duration(milliseconds: 500),
                                    child: Container(
                                      color: AppColors.hover,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: AppColors.f1,
                                    child: const Padding(
                                      padding: EdgeInsets.all(80.0),
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                color: AppColors.f1,
                                child: const Padding(
                                  padding: EdgeInsets.all(80.0),
                                  child: Icon(Icons.error),
                                ),
                              );
                            }
                          }()),
                        ),

                        //wishlist button
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (inWishlist) {
                                  updateWishlist(product.getID, "remove");
                                } else {
                                  updateWishlist(product.getID, "add");
                                }
                                inWishlist =
                                    !inWishlist; //to change icon immediately
                              });
                            },
                            child: SvgPicture.asset(
                              (inWishlist)
                                  ? "assets/icons/icons8_heart.svg"
                                  : "assets/icons/icons8_heart_outline.svg",
                              width: 30,
                              height: 30,
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 8, bottom: 6),
                              primary: Colors.white, // <-- Button color
                              onPrimary: AppColors.black, // <-- Splash color
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
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
              ],
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.getName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: const Text(
                  "Category",
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CartStepper<int>(
                count: _quantity,
                size: 35,
                didChangeCount: (count) {
                  setState(() {
                    if (count > 0) {
                      _quantity = count;
                    } else {
                      _quantity = 1;
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/icons8_shopping_bag.svg",
                    color: AppColors.onPrimary,
                    height: 20,
                    width: 20,
                  ),
                  label: const Text(
                    "ADD TO CART",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateWishlist(String productID, String action) async {
    if (!userSession.logged()) {
      ToastBar.show(context, "You need to login or sign up to add to wishlist!",
          title: "Login Required");
      return;
    }

    Wishlist wishlist = Wishlist(userSession: userSession);
    bool updated = await wishlist.update(userSession.ID, productID, action);

    if (updated) {
      if (action == "remove") {
        inWishlist = false;
        Toaster.show(
            message: "Product removed from wishlist!",
            gravity: ToastGravity.TOP);
      } else {
        inWishlist = true;
        Toaster.show(
            message: "Product added to wishlist!", gravity: ToastGravity.TOP);
      }
    } else {
      Toaster.show(message: "Coudn't update wishlist.");
    }

    setState(() {});
  }
}
