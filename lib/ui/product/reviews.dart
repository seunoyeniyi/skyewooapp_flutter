import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skyewooapp/app_colors.dart';
import 'package:skyewooapp/handlers/app_styles.dart';
import 'package:skyewooapp/models/comment.dart';
import 'package:skyewooapp/ui/product/single_review.dart';

class Reviews extends StatefulWidget {
  const Reviews({
    Key? key,
    required this.haveReviews,
    required this.averageRating,
    required this.reviewsCount,
    required this.comments,
  }) : super(key: key);

  final bool haveReviews;
  final double averageRating;
  final int reviewsCount;
  final List<Comment> comments;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (() {
          if (widget.haveReviews) {
            return Column(
              children: [
                Center(
                  child: RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: widget.averageRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 45,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      //do nothing, not allowed to be changed
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "(" + widget.reviewsCount.toString() + " Customer Reviews)",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  children: List.generate(widget.comments.length, (index) {
                    var comment = widget.comments[index];
                    return SingleReview(
                      comment: comment,
                    );
                  }),
                ),
              ],
            );
          } else {
            return Container(
              color: AppColors.primary,
              padding: const EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  "There are no reviews yet.",
                  style: TextStyle(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            );
          }
        }()),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Your rating *",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 45,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              log(rating.toString());
            },
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Your comment *",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(
              color: AppColors.hover,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const TextField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 5,
            maxLines: 5,
            decoration: InputDecoration.collapsed(
              hintText: 'Comment',
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          style: AppStyles.flatButtonStyle(),
          onPressed: () {},
          child: const Text(
            "Submit Review",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
