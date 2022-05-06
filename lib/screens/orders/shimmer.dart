import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skyewooapp/app_colors.dart';

class OrdersPageShimmer extends StatelessWidget {
  const OrdersPageShimmer({Key? key}) : super(key: key);

  final Color shimBaseColor = AppColors.f1;
  final Color shimHighlightColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: List.generate(5, (index) {
          return Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Shimmer.fromColors(
              baseColor: shimBaseColor,
              highlightColor: shimHighlightColor,
              period: const Duration(milliseconds: 1000),
              child: SizedBox(
                height: 150,
                child: Container(
                  color: AppColors.f1,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
