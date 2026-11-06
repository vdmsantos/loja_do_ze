import 'package:flutter/material.dart';
import '../globals.dart';
import '../helper.dart';
import '../shared/utils/Utils.dart';
import '../modules/produtos/domain/entities/produto.dart';

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
      if (carrinho[i].promo == true) {
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
        backgroundColor: Color(0xFF6200EE),
        foregroundColor: Colors.white,
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
                          color: Color(0xFFEEEEEE),
                          child: Icon(Icons.image, color: Color(0xFF999999)),
                        ),
                        title: Text(carrinho[i].nome!),
                        subtitle: Text("R\$ " +
                            carrinho[i]
                                .getPreco()
                                .toStringAsFixed(2)
                                .replaceAll(".", ",")),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Color(0xFFB00020)),
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
                  color: Color(0xFFF5F5F5),
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
                          Text(Utils.formatarPreco(calculaTotal())),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            Utils.formatarPreco(Helper.get()
                                .calcula(carrinho, cupom, frete, uf)),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6200EE)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6200EE),
                            foregroundColor: Colors.white,
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
                                    Utils.formatarPreco(total) +
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
