import 'package:flutter/material.dart';

import 'package:pi/pages/login_page.dart';
import 'package:pi/entities/cart.dart';

void main() {
  final Cart cart = Cart();

  runApp(MyApp(cart: cart));
}

class MyApp extends StatelessWidget {
  final Cart cart;

  const MyApp({required this.cart});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: LoginPage(),
    );
  }
}
