import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skyewooapp/app_colors.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AppAppBar({Key? key, this.preferredSize = const Size.fromHeight(56.0)})
      : super(key: key);

  @override
  final Size preferredSize;

  @override
  State<AppAppBar> createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            padding: const EdgeInsets.all(5),
            badgeContent: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 12),
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
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/icons8_search.svg",
                    height: 25,
                  )),
            )),
      ],
    );
  }
}
