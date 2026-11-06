import 'package:flutter/material.dart';
import 'package:loja_do_ze/helper.dart';
import 'package:loja_do_ze/main.dart';
import 'package:loja_do_ze/modules/home/views/home_view.dart';
import 'package:loja_do_ze/shared/Utils.dart';
import 'package:loja_do_ze/shared/app_colors.dart';
import 'package:loja_do_ze/shared/app_text_style.dart';
import 'package:loja_do_ze/shared/widgets/app_elevated_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _userTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool l = false;
  String? e;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: AppColors.azul,
        foregroundColor: AppColors.branco,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 32.0),
            Text(
              "Loja do Zé",
              style: AppTextStyle.title.copyWith(color: AppColors.azul)
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: _userTextController,
              decoration: InputDecoration(
                labelText: "Usuário",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordTextController,
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
                    child: AppElevatedButton(onPressed: () 
                       async {
        setState(() {
          l = true;
          e = null;
        });
        await Future.delayed(Duration(seconds: 1));
        if (_userTextController.text == "" || _passwordTextController.text == "") {
          setState(() {
            e = "Preencha tudo";
            l = false;
          });
          return;
        }
        if (Utils.valida(_passwordTextController.text, 2) == false) {
          setState(() {
            e = "Senha tem que ter 6 caracteres";
            l = false;
          });
          return;
        }
        var ok = Helper.get().login(_userTextController.text, _passwordTextController.text);
        if (ok == true) {
          print("logou: " + _userTextController.text + " / " + _passwordTextController.text);
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

                    },),
                  ),
          ],
        ),
      ),
    );
  }
}
