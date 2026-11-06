import 'package:flutter/material.dart';
import 'dart:async';
import 'telas/tela_produtos.dart';
import 'telas/CarrinhoScreen.dart';
import 'Utils.dart';
import 'helper.dart';
import 'globals.dart';
import 'widgets/edit_text.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja do Zé',
      theme: ThemeData(primaryColor: colorPurple),
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
        backgroundColor: colorPurple,
        foregroundColor: colorWhite,
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
                  color: colorPurple),
            ),
            SizedBox(height: 32.0),
            EditText(
              controller: c1,
              labelText: "Usuário",
            ),
            SizedBox(height: 16.0),
            EditText(
              controller: c2,
              labelText: "Senha",
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            e != null
                ? Text(e!, style: TextStyle(color: colorRed))
                : Container(),
            SizedBox(height: 16.0),
            l == true
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPurple,
                        foregroundColor: colorWhite,
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
                        if (Utils.valida(c2.text, 2) == false) {
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
                                builder: (context) => TelaProdutos()),
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
