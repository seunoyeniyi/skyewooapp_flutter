import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/handlers.dart';
import 'package:skyewooapp/handlers/user_session.dart';
import 'package:skyewooapp/screens/order/shimmer.dart';
import 'package:skyewooapp/site.dart';
import 'package:skyewooapp/ui/app_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
    required this.orderID,
  }) : super(key: key);

  final String orderID;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  UserSession userSession = UserSession();
  bool isLoading = true;
  bool hasResult = true;

  //ORDER DETAILS
  String orderStatus = "Unknown status";
  String orderInfo = "";
  //END ORDER DETAILS

  init() async {
    await userSession.init();
    fetchDetails();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.f1,
      appBar: AppBar(
        title: Text("Order #" + widget.orderID),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 20,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          scrollDirection: Axis.vertical,
          child: (() {
            if (isLoading) {
              return const OrderPageShimmer();
            } else if (!isLoading && !hasResult) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchDetails();
                    },
                    child: const Text("Try Again"),
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  //order info
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.hover,
                      ),
                    ),
                    child: Text(
                      orderInfo,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //order process timeline
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Expanded(
                      child: TimelineTile(
                        axis: TimelineAxis.horizontal,
                        alignment: TimelineAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
          }()),
        ),
      ),
    );
  }

  fetchDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      //fetch
      String url = Site.ORDER +
          widget.orderID +
          "/" +
          userSession.ID +
          "?token_key=" +
          Site.TOKEN_KEY;

      Response response = await get(url);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey("code") && json["data"].toString() == "null") {
          Toaster.show(message: json["message"].toString());
          hasResult = false;
        } else {
          hasResult = true;
          switch (json["status"].toString()) {
            case "pending":
              orderStatus = "Pending payment";
              break;
            case "processing":
              orderStatus = "Processing";
              // orderStateProgressBar.setCurrentStateNumber(StateProgressBar.StateNumber.TWO);
              break;
            case "shipped":
              orderStatus = "Shipped";
              // orderStateProgressBar.setCurrentStateNumber(StateProgressBar.StateNumber.FOUR);
              break;
            case "completed":
              orderStatus = "Completed";
              // orderStateProgressBar.setCurrentStateNumber(StateProgressBar.StateNumber.FIVE);
              break;
            case "on-hold":
              orderStatus = "On hold";
              break;
            case "cancelled":
              orderStatus = "Cancelled";
              break;
            case "refunded":
              orderStatus = "Refunded";
              break;
            default:
              break;
          }
          if (json["payment_method"].toString() == "paypal" &&
              json["status"].toString() == "on-hold") {
            orderStatus = "Paypal Cancelled";
          }

          orderInfo = "Order #" +
              json["ID"].toString() +
              " was placed on " +
              json["date_modified_date"].toString() +
              " and is currently " +
              orderStatus +
              ".";

          //end
        }
      } else {
        Toaster.show(message: "No result... This order could not be yours");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
