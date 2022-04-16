import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skyewooapp/handlers/user_session.dart';

import '../../../components/rounded_button.dart';
import '../../app_colors.dart';
import 'background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserSession userSession = UserSession();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await userSession.init();
    checkLogin();
  }

  checkLogin() async {
    await userSession.reload();
    if (userSession.logged()) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "WELCOME",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/chat.svg",
                height: size.height * 0.45,
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "LOG IN",
                press: () async {
                  await Navigator.pushNamed(context, "login").then((value) {
                    checkLogin();
                    setState(() {});
                  });
                },
              ),
              RoundedButton(
                color: AppColors.secondary,
                press: () async {
                  await Navigator.pushNamed(context, "register").then((value) {
                    checkLogin();
                    setState(() {});
                  });
                },
                text: 'SIGN UP',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
