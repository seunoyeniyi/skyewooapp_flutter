import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/ui/drawer_widget.dart';

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyHomePageState>()!.restartApp();
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: Scaffold(
        appBar: AppBar(
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
        ),
        drawer: const AppDrawer(),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.call),
        //       label: 'Calls',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.camera),
        //       label: 'Camera',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: 'Chats',
        //     ),
        //   ],
        // ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '0',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
