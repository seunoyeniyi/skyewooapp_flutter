// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:skyewooapp/components/loading_box.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/screens/login/background.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:skyewooapp/site.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
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
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.25,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                controller: usernameController,
                hintText: "Username or email",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: passwordController,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                press: _submit,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.pushReplacementNamed(context, "register");
                },
              ),
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
        title: "Username or Email!",
        message: "Please enter your username or email",
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

    SmartDialog.showLoading(widget: const LoadingBox());

    String url = Site.LOGIN + "?token_key=" + Site.TOKEN_KEY;

    dynamic data = {
      "username": usernameController.text,
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
          Toast.show(context, "Incorrect login details!",
              title: "Access Denied");
        } else {
          Map<String, dynamic> data = json["data"];

          //save user session
          userSession.createLoginSession(
              userID: data["ID"],
              xusername: data["user_login"],
              xemail: data["user_email"],
              logged: true);
          // Toast.show(context, "Welcome Back!", title: "Success"); //causes error here, should be used on home page or checkout page
          userSession.reload();
          SmartDialog.dismiss();

          //check where to go after succesful login
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
          });
        }
      } else {
        SmartDialog.dismiss();
        Toast.show(context, "Coudn't get any result!");
      }
    } else {
      SmartDialog.dismiss();
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error!",
        message: "Access denied, please re-check your details.",
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
