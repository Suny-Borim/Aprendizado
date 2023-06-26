
import 'package:pi/entities/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cart {
  final List<Product> _items = [];
  List<Product> itemsCart = [];

  List<Product> get items => _items;

  Future<void> add(Product product) async {
    _items.add(product);
    final url = Uri.parse('http://localhost:3000/cart');

    final data = {
      'userId': 1,
      'id': product.id,
      'quantidade': 1,
      'title': product.title,
      'price': product.price,
      'image': product.image
    };

    final headers = {'Content-Type': 'application/json'};

    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 201) {
      print('Item adicionado com sucesso!');
    } else {
      print(
          'Erro ao adicionar ao carrinho. Código de status: ${response.statusCode}');
    }
  }

  Future<void> remove(Product product) async {
    final index = _items.indexOf(product);
    if (index >= 0) {
      _items.removeAt(index);
    }

    final productId = await buscarIdJsonServer(product);

    final url = Uri.parse('http://localhost:3000/cart/$productId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Item excluído com sucesso!');
    } else {
      throw Exception(
          'Erro ao excluir item do carrinho. Código de status: ${response.statusCode}');
    }
  }

  Future<String> buscarIdJsonServer(Product product) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/cart?id=${product.id}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData.length > 0) {
        return jsonData[0]['id'].toString();
      }
    }

    throw Exception('Falha ao buscar ID do produto');
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

  double get total => _items.fold(0, (sum, item) => sum + item.price);
}
