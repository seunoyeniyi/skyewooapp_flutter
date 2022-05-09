import 'package:flutter/material.dart';
import 'package:skyewooapp/components/input_form.dart';
import 'package:skyewooapp/handlers/app_styles.dart';
import 'package:skyewooapp/handlers/user_session.dart';

class CheckoutAddressPage extends StatefulWidget {
  const CheckoutAddressPage({Key? key}) : super(key: key);

  @override
  State<CheckoutAddressPage> createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  UserSession userSession = UserSession();
  TextStyle labelStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  //controls
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var companyController = TextEditingController();
  var genderController = TextEditingController();
  var dobController = TextEditingController();
  var countryController = TextEditingController();
  var address1Controller = TextEditingController();
  var address2Controller = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var postcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var phone2Controller = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await userSession.init();
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // Add Your Code here.
        fetchAddress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Shipping Address"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text("First Name", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: firstNameController,
                hintText: "First Name",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Last Name", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: lastNameController,
                hintText: "Last Name",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Company", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: companyController,
                hintText: "Company",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Gender", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: genderController,
                hintText: "Gender",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Date of Birth", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: dobController,
                keyboardType: TextInputType.datetime,
                hintText: "Date of Birth",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text("Country", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: countryController,
                hintText: "Country",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Street Address", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: address1Controller,
                hintText: "House number, and street name",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              InputForm(
                controller: address2Controller,
                hintText: "Apartment, suite, unit etc. (Optional)",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("State", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: stateController,
                hintText: "State",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("City", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: cityController,
                hintText: "City",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Post code", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: postcodeController,
                hintText: "Post code",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Phone", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                hintText: "Phone",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              InputForm(
                controller: phone2Controller,
                keyboardType: TextInputType.phone,
                hintText: "Altanate Phone",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              Text("Email", style: labelStyle),
              const SizedBox(height: 10),
              InputForm(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
                fontSize: 18,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              TextButton(
                style: AppStyles.flatButtonStyle(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                ),
                onPressed: () {
                  saveAddress();
                },
                child: const Text(
                  "SAVE",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  fetchAddress() async {}

  saveAddress() async {}
}
