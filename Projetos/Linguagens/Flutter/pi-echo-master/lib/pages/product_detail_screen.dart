import 'dart:convert';

import 'package:pi/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:pi/pages/Cart_screen.dart';
import 'package:pi/entities/cart.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Cart cart;

  const ProductDetailsScreen({Key? key, required this.product, required this.cart})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: widget.cart)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.product.image),
              SizedBox(height: 16),
              Text(
                widget.product.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Preço: \$${widget.product.price}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                widget.product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  widget.cart.add(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produto adicionado ao carrinho!'),
                    ),
                  );
                },
                child: Text('Adicionar ao carrinho'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}