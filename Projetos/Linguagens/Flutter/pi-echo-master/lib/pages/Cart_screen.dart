import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi/entities/product.dart';
import 'package:pi/entities/cart.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> itemsCart = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final url = Uri.parse('http://localhost:3000/cart');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        itemsCart =
            List<Product>.from(jsonData.map((item) => Product.fromJson(item)));
      });
    } else {
      print(
          'Erro ao buscar itens do carrinho. Código de status: ${response.statusCode}');
    }
  }

  double calculateTotal(List<Product> items) {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantidade;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  Future<List<Product>> guardarItensLista() async {
    final url = Uri.parse('http://localhost:3000/cart');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List<Product> itemsCart =
          jsonData.map<Product>((item) => Product.fromJson(item)).toList();

      return itemsCart;
    } else {
      throw Exception(
          'Erro ao buscar itens do carrinho. Código de status: ${response.statusCode}');
    }
  }

  Future<void> updateCartItem(Product product) async {
    final url = Uri.parse('http://localhost:3000/cart/${product.id}');
    final data = {'quantidade': product.quantidade};
    final headers = {'Content-Type': 'application/json'};

    final response =
        await http.patch(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Quantidade do produto atualizada com sucesso: ${product.id}');
    } else {
      print(
          'Erro ao atualizar quantidade do produto: ${product.id}. Código de status: ${response.statusCode}');
    }
  }
  
   Future<void> finalizarCompra() async {
    if (itemsCart.isEmpty) {
      return;
    }

    final url = Uri.parse('http://localhost:3000/sale');

    final itemsMap = itemsCart
        .map((product) => {
              'productId': product.id,
              'quantidade': product.quantidade,
              'productName': product.title,
              'price': product.price * product.quantidade,
            })
        .toList();

    final data = {
      'userId': 1,
      'data': DateTime.now().toIso8601String(),
      'produtos': itemsMap,
      'valorTotal': calculateTotal(itemsCart),
    };

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 201) {
      print('Compra finalizada com sucesso!');

      removeAll();
    } else {
      print('Erro ao finalizar a compra. Código de status: ${response.statusCode}');
    }
  }

  Future<void> removeAll() async {
    final url = Uri.parse('http://localhost:3000/cart');

    for (Product product in widget.cart.items) {
      final response = await http.delete(Uri.parse('$url/${product.id}'));
      if (response.statusCode == 200) {
        print('Item removido com sucesso: ${product.id}');
      } else {
        print(
            'Erro ao remover item: ${product.id}. Código de status: ${response.statusCode}');
      }
    }

    widget.cart.items.clear();
  }

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
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemsCart.length,
                        itemBuilder: (context, index) {
                          final product = itemsCart[index];
                          return ListTile(
                            leading: Image.network(product.image),
                            title: Text(product.title),
                            subtitle: Text('Preço: \$${(product.price * product.quantidade).toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (product.quantidade > 1) {
                                        product.quantidade--;
                                        updateCartItem(product);
                                      }
                                    });
                                  },
                                ),
                                Text(product.quantidade.toString()),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      product.quantidade++;
                                      updateCartItem(product);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      widget.cart.remove(product);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total: \$${calculateTotal(itemsCart)}',
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
                finalizarCompra();
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
