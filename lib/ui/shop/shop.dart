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
    return SingleChildScrollView(
      child: Column(
        children: [
          Material(
            elevation: 1,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 50,
              child: const Center(
                child: Text("Head"),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            color: Colors.white,
            child: Column(
              children: const [
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
                Text("Shop", style: TextStyle(fontSize: 30)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
