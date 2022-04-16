import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/main.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserSession userSession = UserSession();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await userSession.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListTileTheme(
          textColor: Colors.black,
          iconColor: Colors.black,
          horizontalTitleGap: 2,
          contentPadding: const EdgeInsets.only(left: 30),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              //DRAWER HEADER
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            "assets/images/boy_man_avatar.png",
                            height: 70,
                            width: 70,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      (userSession.logged())
                                          ? userSession.username
                                          : "Hi!",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                margin: const EdgeInsets.only(bottom: 5),
                              ),
                              SizedBox(
                                height: 25,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: loginTapped,
                                  child: Text(
                                    (userSession.logged())
                                        ? "Account"
                                        : "Log In",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //DRAWER LISTS
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/icons8_home.svg",
                  height: 25,
                  width: 25,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  MyHomePage.changeBody(context, 0);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/icons8_shopping_bag.svg",
                  height: 25,
                  width: 25,
                ),
                title: const Text(
                  'Shop',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  MyHomePage.changeBody(context, 1);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/icons8_fantasy_1.svg",
                  height: 25,
                  width: 25,
                ),
                title: const Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/icons8_heart_outline.svg",
                  height: 25,
                  width: 25,
                ),
                title: const Text(
                  'Wishlist',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/icons8_basket.svg",
                  height: 25,
                  width: 25,
                ),
                title: const Text(
                  'Orders',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onTap: () {},
              ),

              const SizedBox(height: 30),

              ListTile(
                title: const Text(
                  'Contact',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  (userSession.logged()) ? "Log Out" : "Log In",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: logoutTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginTapped() {
    Navigator.pop(context);
    if (userSession.logged()) {
      //go to account
    } else {
      Navigator.pushNamed(context, "welcome");
    }
  }

  logoutTapped() {
    Navigator.pop(context);
    if (userSession.logged()) {
      userSession.logout();
      MyHomePage.restartApp(context);
    } else {
      Navigator.pushNamed(context, "welcome");
    }
  }
}
