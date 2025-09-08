import 'package:flutter/material.dart';

import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';


class Search extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Search());
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Search'),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomNavigationBar(),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
