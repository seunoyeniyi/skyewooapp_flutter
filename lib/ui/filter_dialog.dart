// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/components/swatch_card.dart';
import 'package:skyewooapp/handlers/app_styles.dart';
import 'package:skyewooapp/models/category.dart';
import 'package:skyewooapp/models/option.dart';
import 'package:skyewooapp/models/tag.dart';
import 'package:skyewooapp/site.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  //LIST
  List<Category> categories = [
    Category(name: "Select a category", slug: "")
  ]; //default
  List<Tag> tags = [Tag(name: "Select a tag", slug: "")]; //default
  // List<AttributeTerm> sizes = [AttributeTerm(name: "Any", slug: "")]; //default for size
  List<Option> colors = [Option(name: "", value: "Any")];

  //### DEAULT VALUES
  double initialLower = 100;
  double initialUpper = 13000;
  double maximumPrice = 15000;
  int selectedCatIndex = 0;
  String selected_category = "";
  int selectedTagIndex = 0;
  String selected_tag = "";
  int selectedColorIndex = 0;
  String selected_color = "";
  RangeValues priceRange = const RangeValues(100,
      13000); //shoudld have used initialLower and initialUpper, but dart won't allow

  @override
  void initState() {
    priceRange =
        RangeValues(initialLower, initialUpper); //initialize default range
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TITLE
          Container(
            color: Colors.black,
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.sort,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Filter",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.primaryHover;
                        }
                        return Colors.transparent;
                      }),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          // const Divider(color: Colors.grey),
          //BODY
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //######Category#######
                  const Text(
                    " Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.hover,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<Category>(
                            isExpanded: true,
                            value: categories[selectedCatIndex],
                            icon: const Icon(Icons.arrow_drop_down),
                            items: categories.map((Category item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.getName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCatIndex = categories.indexOf(value!);
                                selected_category = value.getSlug;
                              });
                            },
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: categories.length < 2,
                        child: const Positioned(
                          top: 14,
                          right: 7,
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  //######End Category#######

                  //######Colour#######
                  const Text(
                    "Colour",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.hover,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: GridView.count(
                          crossAxisCount: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 3,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(colors.length, (index) {
                            return SwatchCard(
                              name: colors[index].getValue,
                              slug: colors[index].getName,
                              selected: index == selectedColorIndex,
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Visibility(
                        visible: colors.length < 2,
                        child: const Positioned(
                          top: 30,
                          right: 30,
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //######End Colour#######

                  //######Price#######
                  const Text(
                    " Price",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.hover,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            Site.CURRENCY +
                                priceRange.start.round().toString() +
                                " - " +
                                Site.CURRENCY +
                                priceRange.end.round().toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        RangeSlider(
                          min: 0,
                          max: maximumPrice,
                          values: priceRange,
                          divisions: 20,
                          labels: RangeLabels(
                            priceRange.start.round().toString(),
                            priceRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              priceRange = values;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //######End Price#######

                  //######Tag#######
                  const Text(
                    " Tag",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.hover,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<Tag>(
                            isExpanded: true,
                            value: tags[selectedTagIndex],
                            icon: const Icon(Icons.arrow_drop_down),
                            items: tags.map((Tag item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.getName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTagIndex = tags.indexOf(value!);
                                selected_tag = value.getSlug;
                              });
                            },
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: tags.length < 2,
                        child: const Positioned(
                          top: 14,
                          right: 7,
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //######End Tag#######

                  const SizedBox(height: 30),

                  TextButton(
                    style: AppStyles.flatButtonStyle(),
                    onPressed: () {
                      Navigator.pop(context, "submit back result");
                    },
                    child: const Text(
                      "Apply Filter",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
