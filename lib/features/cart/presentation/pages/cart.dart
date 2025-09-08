import 'package:flutter/material.dart';

import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';

class Cart extends StatefulWidget {

  //static  route() => MaterialPageRoute(builder: (context) => Cart());
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Screen'),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
      body: Column(
        children: [
          Text('Hello'),
        ],
      ),
    );
  }
}
