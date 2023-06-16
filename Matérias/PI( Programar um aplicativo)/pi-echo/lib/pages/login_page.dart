import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi/pages/product_list_screen.dart';
import 'package:pi/entities/cart.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  Cart cart = new Cart();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  void _submitForm() async {
    /*  print("usuario:" + _username);
    print("senha:" + _password); */
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final loginData = {'username': _username, 'password': _password};
      final loginDataJson = json.encode(loginData);
      final response = await fetchLoginData(loginDataJson);
      if (response == 'success') {
        // exibir mensagem de sucesso
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductListScreen(
                    cart: cart,
                  )),
        );
      } else {
        // exibir mensagem de erro
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Erro de login'),
            content:
                Text('Verifique suas credenciais de login e tente novamente.'),
          ),
        );
      }
    }
  }

  Future<String> fetchLoginData(loginDataJson) async {
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: loginDataJson,
    );
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Color(0xFFF2E2CE),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 200,
                child: Image.asset("assets/Logo.png"),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
                decoration: InputDecoration(
                  labelText: "Usuário",
                  labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 40,
                alignment: Alignment.centerRight,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFE3762B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFE3762B)),
                      // Modifica a cor de fundo do botão
                    ),
                    onPressed: () {
                      _submitForm();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Acessar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
