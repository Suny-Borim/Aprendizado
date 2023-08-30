import 'dart:html';

import 'package:flutter/material.dart';
import 'package:pi/entities/product.dart';
import 'package:pi/entities/cart.dart';

class CartScreen extends StatelessWidget {
  final Cart cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        backgroundColor: Color(0xFFE3762B),
      ),
      backgroundColor: Color(0xFFF2E2CE),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.title),
                      subtitle: Text('Preço: \$${product.price}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          cart.remove(product);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total: \$${cart.total}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFE3762B),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                cart.finalizarCompra(cart.items);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF38221f),
              ),
              child: Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}