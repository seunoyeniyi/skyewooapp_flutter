import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:skyewooapp/components/loading_box.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/site.dart';
// import 'package:skyewooapp/screens/signup/components/social_icon.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import 'background.dart';
// import 'components/or_divider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserSession userSession = UserSession();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await userSession.init();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
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
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.25,
              ),
              RoundedInputField(
                controller: usernameController,
                hintText: "Username",
                onChanged: (value) {},
              ),
              RoundedInputField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
                icon: Icons.alternate_email,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: passwordController,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "SIGNUP",
                press: _submit,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pushReplacementNamed(context, "login");
                },
              ),
              // const OrDivider(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     SocalIcon(
              //       iconSrc: "assets/icons/facebook.svg",
              //       press: () {},
              //     ),
              //     SocalIcon(
              //       iconSrc: "assets/icons/twitter.svg",
              //       press: () {},
              //     ),
              //     SocalIcon(
              //       iconSrc: "assets/icons/google-plus.svg",
              //       press: () {},
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    FocusScope.of(context).unfocus();

    if (usernameController.text.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Username!",
        message: "Please enter your username",
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    if (emailController.text.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Email!",
        message: "Please enter your email",
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Email!",
        message: "Email is not a valid email address",
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    if (passwordController.text.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Password!",
        message: "Please enter your password",
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    //START
    SmartDialog.showLoading(widget: const LoadingBox());

    String url = Site.REGISTER + "?token_key=" + Site.TOKEN_KEY;

    dynamic data = {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "token_key": Site.TOKEN_KEY,
    };

    if (userSession.ID != "0") {
      //ID maybe hash code for anonymous user
      data["replace_cart_user"] = userSession.ID;
    }

    Response response = await post(url, body: data);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.isNotEmpty) {
        if (json.containsKey("code") ||
            json["data"] == null ||
            json["data"] == "null") {
          SmartDialog.dismiss();
          if (json.containsKey("message")) {
            ToastBar.show(context, json["message"], title: "");
          } else {
            ToastBar.show(
                context, "Unable to get you registered at the moment!",
                title: "Access Denied");
          }
        } else {
          Map<String, dynamic> data = json["data"];

          //save user session
          userSession.createLoginSession(
              userID: data["ID"],
              xusername: data["user_login"],
              xemail: data["user_email"],
              logged: true);
          // Toast.show(context, "Registration completed!", title: "Success"); //causes error here, should be used on home page or checkout page
          Toaster.show(message: "Registration completed!");
          userSession.reload();
          SmartDialog.dismiss();

          //check where to go after succesful login
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
          });
        }
      } else {
        SmartDialog.dismiss();
        ToastBar.show(context, "Coudn't get any result!");
      }
    } else {
      SmartDialog.dismiss();
      Map<String, dynamic> json = jsonDecode(response.body);
      String message = "Something is wrong - Check your input details";
      if (json.isNotEmpty) {
        if (json.containsKey("message")) {
          message = json["message"];
        }
      }
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error!",
        message: message,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
