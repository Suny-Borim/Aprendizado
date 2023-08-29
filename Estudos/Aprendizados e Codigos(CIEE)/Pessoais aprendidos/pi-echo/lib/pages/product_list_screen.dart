import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi/entities/product.dart';
import 'package:pi/pages/product_detail_screen.dart';
import 'package:pi/pages/Cart_screen.dart';
import 'package:pi/entities/cart.dart';

class ProductListScreen extends StatefulWidget {
  final Cart cart;

  const ProductListScreen({required this.cart});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _showProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailsScreen(product: product, cart: widget.cart),
      ),
    );
  }

  void _searchProduct(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(cart: widget.cart)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProduct,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<Product> filteredProducts = _searchQuery.isEmpty
                      ? snapshot.data!
                      : snapshot.data!
                          .where((product) => product.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => _showProductDetails(product),
                        child: ListTile(
                          leading: Image.network(product.image),
                          title: Text(product.title),
                          subtitle: Text("Preço: " + product.price.toString()),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
