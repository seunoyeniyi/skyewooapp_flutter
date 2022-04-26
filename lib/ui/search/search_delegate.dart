import 'package:flutter/material.dart';

class AppBarSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null); //close searchbar
            } else {
              query = "";
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); //close searchbar
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO0: implement buildResults
    return const Center(
      child: Text("TODO Results"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO0: implement buildSuggestions
    return const Text("Todo");
  }
}
