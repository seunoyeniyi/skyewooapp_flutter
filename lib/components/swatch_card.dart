import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:skyewooapp/app_colors.dart';

class SwatchCard extends StatefulWidget {
  const SwatchCard({
    Key? key,
    required this.name,
    required this.slug,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String slug;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<SwatchCard> createState() => _SwatchCardState();
}

class _SwatchCardState extends State<SwatchCard> {
  List<Map<String, Color>> registeredColros = [
    {"blue": Colors.blue},
    {"red": Colors.red},
    {"green": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: (() {
            for (var element in registeredColros) {
              if (element.containsKey(widget.slug)) {
                return element[widget.slug];
              }
            }
            return Colors.white;
          }()),
          border: Border.all(
            color: (() {
              if (widget.selected) {
                return Colors.black;
              }
              for (var element in registeredColros) {
                if (element.containsKey(widget.slug)) {
                  return element[widget.slug]!;
                }
              }
              return AppColors.f1;
            }()),
            style: BorderStyle.solid,
            width: widget.selected ? 3.0 : 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: TextStyle(
              fontSize: 10,
              color: (() {
                for (var element in registeredColros) {
                  if (element.containsKey(widget.slug)) {
                    return Colors.white;
                  }
                }
                return Colors.black;
              }()),
            ),
          ),
        ),
      ),
    );
  }
}
