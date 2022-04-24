import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/ui/home/home.dart';
import 'package:skyewooapp/screens/login/login_screen.dart';
import 'package:skyewooapp/screens/signup/signup_screen.dart';
import 'package:skyewooapp/screens/welcome/welcome_screen.dart';
import 'package:skyewooapp/ui/app_bar.dart';
import 'package:skyewooapp/ui/app_drawer.dart';
import 'package:skyewooapp/ui/shop/shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woo App',
      theme: ThemeData(
        fontFamily: "Montserrat",
        primarySwatch: AppColors.primarySwatch,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Woo App'),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      routes: {
        "welcome": (BuildContext context) => const WelcomeScreen(),
        "login": (BuildContext context) => const LoginScreen(),
        "register": (BuildContext context) => const SignUpScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyHomePageState>()!.restartApp();
  }

  static void changeBody(BuildContext context, int body) {
    context.findAncestorStateOfType<_MyHomePageState>()!.changeBody(body);
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key? key = UniqueKey();

  final List<Widget> bodies = [
    const ShopBody(key: PageStorageKey("ShopBody")),
    const HomeBody(key: PageStorageKey("HomeBody")),
  ];
  int _bodyIndex = 0;

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  void changeBody(int body) {
    setState(() {
      _bodyIndex = body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: Scaffold(
        appBar: const AppAppBar(),
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: _bodyIndex,
          children: bodies,
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
