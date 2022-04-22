import 'package:flutter/material.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/components/product_card.dart';
import 'package:skyewooapp/models/products.dart';

class ShopBody extends StatefulWidget {
  const ShopBody({Key? key}) : super(key: key);

  @override
  State<ShopBody> createState() => _ShopBodyState();
}

class _ShopBodyState extends State<ShopBody> {
  String title = "Shop";

  // Initial Selected Value
  String sortDropdownValue = 'Default sorting';

  // List of items in our dropdown menu
  var sortItems = [
    'Default sorting',
    'Sort by popularity',
    'Sort by average rating',
    'Sort by latest',
    'Sort by price: low to high',
    'Sort by price: high to low',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Material(
            //header container
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.all(0),
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.f1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        isExpanded: true,
                        value: sortDropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: sortItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            sortDropdownValue = newValue!;
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Material(
                      color: Colors.white,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //SHOP PRODUCTS
          Container(
            margin: const EdgeInsets.only(top: 5),
            color: Colors.white,
            child: const Center(
              child: Text("Shop"),
            ),
          )
        ],
      ),
    );
  }

  List<Product> products = <Product>[
    Product(name: "Home", id: "1"),
    Product(name: 'Contact', id: "1"),
    Product(name: 'Map', id: "1"),
    Product(name: 'Phone', id: "1"),
    Product(name: 'Camera', id: "1"),
    Product(name: 'Setting', id: "1"),
    Product(name: 'Album', id: "1"),
    Product(name: 'WiFi', id: "1"),
  ];
}
