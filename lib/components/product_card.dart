// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/formatter.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/site.dart';
import 'package:html_character_entities/html_character_entities.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {Key? key,
      required this.productTitle,
      required this.image,
      required this.regularPrice,
      required this.price,
      required this.inWishlist,
      required this.discountValue})
      : super(key: key);

  final String productTitle;
  final String image;
  final String regularPrice;
  final String price;
  final bool inWishlist;
  final String discountValue;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Color bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            primary: Colors.white,
            onPrimary: AppColors.hover,
            shadowColor: Colors.transparent,
          ),
          onPressed: () => {},
          child: Column(
            children: [
              Container(
                height: 170,
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.f1,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.f1,
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 500),
                        child: Container(
                          color: AppColors.hover,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Padding(
                        padding: EdgeInsets.all(80.0),
                        child: Icon(Icons.error),
                      ),
                    )),
              ),
              Container(
                color: Colors.transparent,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                      child: Text(
                        HtmlCharacterEntities.decode(widget.productTitle),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // PROUDCT TITLE, PRICES
                    Row(
                      children: [
                        Visibility(
                          visible: (widget.regularPrice.isNotEmpty &&
                              widget.regularPrice != "0" &&
                              isNumeric(widget.regularPrice)),
                          child: Text(
                            Site.CURRENCY +
                                Formatter.format(widget.regularPrice),
                            style: const TextStyle(
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          Site.CURRENCY + Formatter.format(widget.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 120,
          child: ElevatedButton(
            onPressed: () {},
            child: SvgPicture.asset(
              (widget.inWishlist)
                  ? "assets/icons/icons8_heart.svg"
                  : "assets/icons/icons8_heart_outline.svg",
              width: 17,
              height: 17,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              shape: const CircleBorder(),
              padding:
                  const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 6),
              primary: Colors.white, // <-- Button color
              onPrimary: AppColors.black, // <-- Splash color
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Visibility(
            visible: (widget.discountValue.isNotEmpty &&
                double.parse(widget.discountValue) > 0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 2),
                child: Text(
                  "Save " +
                      double.parse(widget.discountValue).toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
