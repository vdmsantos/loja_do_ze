import 'package:flutter/material.dart';
import 'dart:async';
import 'modules/produtos/presenter/produto_page.dart';
import 'telas/carrinho_page.dart';
import 'shared/utils/Utils.dart';
import 'helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja do Zé',
      theme: ThemeData(primaryColor: Color(0xFF6200EE)),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var c1 = TextEditingController();
  var c2 = TextEditingController();
  bool l = false;
  String? e;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFF6200EE),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 32.0),
            Text(
              "Loja do Zé",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE)),
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: c1,
              decoration: InputDecoration(
                labelText: "Usuário",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: c2,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            e != null
                ? Text(e!, style: TextStyle(color: Color(0xFFB00020)))
                : Container(),
            SizedBox(height: 16.0),
            l == true
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6200EE),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {
                          l = true;
                          e = null;
                        });
                        await Future.delayed(Duration(seconds: 1));
                        if (c1.text == "" || c2.text == "") {
                          setState(() {
                            e = "Preencha tudo";
                            l = false;
                          });
                          return;
                        }
                        if (Utils.validaEmail(c2.text, 2) == false) {
                          setState(() {
                            e = "Senha tem que ter 6 caracteres";
                            l = false;
                          });
                          return;
                        }
                        var ok = Helper.get().login(c1.text, c2.text);
                        if (ok == true) {
                          print("logou: " + c1.text + " / " + c2.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProdutoPage()),
                          );
                        } else {
                          setState(() {
                            e = "Usuário ou senha inválidos";
                            l = false;
                          });
                        }
                      },
                      child: Text("Entrar"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
