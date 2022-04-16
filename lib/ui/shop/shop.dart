import 'package:flutter/material.dart';

class ShopBody extends StatefulWidget {
  const ShopBody({Key? key}) : super(key: key);

  @override
  State<ShopBody> createState() => _ShopBodyState();
}

class _ShopBodyState extends State<ShopBody> {
  String title = "Shop";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(children: <Widget>[
          Text(title),
          ElevatedButton(
            onPressed: () {
              setState(() {
                title = "Shopppppper";
              });
            },
            child: const Text("Click"),
          )
        ]),
      ),
    );
  }
}
