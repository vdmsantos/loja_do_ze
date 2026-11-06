import 'package:flutter/material.dart';
import '../globals.dart';
import '../helper.dart';
import '../Utils.dart';
import '../models/produto.dart';
import '../colors.dart';

class CarrinhoScreen extends StatefulWidget {
  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  bool cupom = false;
  bool frete = true;
  String? uf = "SC";

  // calcula o total
  double calculaTotal() {
    double t = 0;
    for (int i = 0; i < carrinho.length; i++) {
      if (carrinho[i].promocao == true) {
        t += carrinho[i].preco - (carrinho[i].preco * 0.15);
      } else {
        t += carrinho[i].preco;
      }
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
        backgroundColor: colorPurple,
        foregroundColor: colorWhite,
      ),
      body: carrinho.length == 0
          ? Center(child: Text("Carrinho vazio"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carrinho.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          color: colorSoftGray,
                          child: Icon(Icons.image, color: colorMediumGray),
                        ),
                        title: Text(carrinho[i].nome!),
                        subtitle: Text("R\$ " +
                            carrinho[i]
                                .getPreco()
                                .toStringAsFixed(2)
                                .replaceAll(".", ",")),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: colorRed),
                          onPressed: () {
                            Helper.get().removeCarrinho(i);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: colorBackground,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text("Usar cupom"),
                        value: cupom,
                        onChanged: (v) {
                          setState(() {
                            cupom = v;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text("Entrega"),
                        value: frete,
                        onChanged: (v) {
                          setState(() {
                            frete = v;
                          });
                        },
                      ),
                      frete == true
                          ? Row(
                              children: [
                                Text("Estado: "),
                                DropdownButton<String>(
                                  value: uf,
                                  items: [
                                    "SC",
                                    "PR",
                                    "RS",
                                    "SP",
                                    "RJ",
                                    "MG",
                                    "BA"
                                  ]
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      uf = v;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal"),
                          Text(Utils.formata(calculaTotal())),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            Utils.formata(Helper.get()
                                .calcula(carrinho, cupom, frete, uf)),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorPurple),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPurple,
                            foregroundColor: colorWhite,
                          ),
                          onPressed: () async {
                            if (usuarioLogado == null) {
                              Helper.get()
                                  .mostraMsg(context, "Faça login", true);
                              return;
                            }
                            await showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: Text("Pedido feito!"),
                                content: Text("Total: " +
                                    Utils.formata(total) +
                                    "\nObrigado pela compra!"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(c),
                                      child: Text("OK")),
                                ],
                              ),
                            );
                            carrinho.clear();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("Finalizar compra"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
