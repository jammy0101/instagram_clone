import 'package:flutter/material.dart';

import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';

class Feed extends StatefulWidget {
  static  route() => MaterialPageRoute(builder: (context) => Feed());
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
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
