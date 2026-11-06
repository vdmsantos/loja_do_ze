import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../../../helper.dart';
import '../../../globals.dart';
import '../../../shared/utils.dart';
import '../../cart/views/cart_page.dart';

class TelaProdutos extends StatefulWidget {
  @override
  _TelaProdutosState createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  List<Produto>? produtos;
  List<Produto>? produtosFiltrados;
  bool carregando = true;
  bool erro = false;
  String busca = "";
  String filtro = "todos";
  int x = 0;

  @override
  void initState() {
    super.initState();
    carrega();
  }

  void carrega() async {
    setState(() {
      carregando = true;
      erro = false;
    });
    var r = await Helper.get().getProdutos();
    if (r == null) {
      setState(() {
        erro = true;
        carregando = false;
      });
    } else {
      setState(() {
        produtos = r;
        produtosFiltrados = r;
        carregando = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos (" + qtd.toString() + ")"),
        backgroundColor: Color(0xFF6200EE),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (c) => CartPage()))
                  .then((v) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: carregando
          ? Center(child: CircularProgressIndicator())
          : erro
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Deu erro :("),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                          onPressed: () {
                            carrega();
                          },
                          child: Text("Tentar de novo")),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Buscar...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) {
                          busca = v;
                          setState(() {
                            produtosFiltrados = produtos!
                                .where((p) =>
                                    p.nome!
                                        .toLowerCase()
                                        .contains(busca.toLowerCase()) &&
                                    (filtro == "todos" || p.categoria == filtro))
                                .toList();
                          });
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text("Todos"),
                            selected: filtro == "todos",
                            onSelected: (s) {
                              setState(() {
                                filtro = "todos";
                                produtosFiltrados = produtos!
                                    .where((p) => p.nome!
                                        .toLowerCase()
                                        .contains(busca.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          ChoiceChip(
                            label: Text("Roupas"),
                            selected: filtro == "roupas",
                            onSelected: (s) {
                              setState(() {
                                filtro = "roupas";
                                produtosFiltrados = produtos!
                                    .where((p) =>
                                        p.nome!
                                            .toLowerCase()
                                            .contains(busca.toLowerCase()) &&
                                        p.categoria == "roupas")
                                    .toList();
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          ChoiceChip(
                            label: Text("Casa"),
                            selected: filtro == "casa",
                            onSelected: (s) {
                              setState(() {
                                filtro = "casa";
                                produtosFiltrados = produtos!
                                    .where((p) =>
                                        p.nome!
                                            .toLowerCase()
                                            .contains(busca.toLowerCase()) &&
                                        p.categoria == "casa")
                                    .toList();
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          ChoiceChip(
                            label: Text("Acessórios"),
                            selected: filtro == "acessorios",
                            onSelected: (s) {
                              setState(() {
                                filtro = "acessorios";
                                produtosFiltrados = produtos!
                                    .where((p) =>
                                        p.nome!
                                            .toLowerCase()
                                            .contains(busca.toLowerCase()) &&
                                        p.categoria == "acessorios")
                                    .toList();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // destaques
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Promoções",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          for (var p in produtos!)
                            if (p.desconto == true)
                              Container(
                                width: 140,
                                margin: EdgeInsets.only(right: 8.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Color(0xFFDDDDDD)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.local_offer,
                                        color: Color(0xFFB00020)),
                                    SizedBox(height: 4),
                                    Text(p.nome!,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Text(
                                      "R\$ " +
                                          (p.preco - (p.preco * 0.15))
                                              .toStringAsFixed(2)
                                              .replaceAll(".", ","),
                                      style: TextStyle(
                                          color: Color(0xFF6200EE),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (p.estoque! > 0) {
                                          Helper.get().addCarrinho(p);
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                p.nome! + " adicionado!"),
                                            backgroundColor: Color(0xFF03DAC6),
                                            duration:
                                                Duration(milliseconds: 1500),
                                          ));
                                        }
                                      },
                                      child: Text("+ Adicionar",
                                          style: TextStyle(
                                              color: Color(0xFF03DAC6))),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: produtosFiltrados!.length,
                        itemBuilder: (context, i) {
                          var p = produtosFiltrados![i];
                          if (p.status == "inativo") {
                            return Container();
                          }
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Color(0xFFEEEEEE),
                                    child: Icon(Icons.image,
                                        color: Color(0xFF999999)),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p.nome!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        p.desconto == true
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "R\$ " +
                                                        p.preco
                                                            .toStringAsFixed(2)
                                                            .replaceAll(
                                                                ".", ","),
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color:
                                                            Color(0xFF999999)),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "R\$ " +
                                                        (p.preco -
                                                                (p.preco *
                                                                    0.15))
                                                            .toStringAsFixed(2)
                                                            .replaceAll(
                                                                ".", ","),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF6200EE),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                Utils.formata(p.getPreco()),
                                                style: TextStyle(
                                                    color: Color(0xFF6200EE),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        SizedBox(height: 4),
                                        Text(
                                          p.estoque == 0 ||
                                                  p.status == "esgotado"
                                              ? "Esgotado"
                                              : p.estoque! < 5
                                                  ? "Últimas " +
                                                      p.estoque.toString() +
                                                      " unidades!"
                                                  : "Disponível",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: p.estoque == 0 ||
                                                    p.status == "esgotado"
                                                ? Color(0xFFB00020)
                                                : p.estoque! < 5
                                                    ? Colors.orange
                                                    : Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_shopping_cart,
                                        color: p.estoque == 0
                                            ? Color(0xFF999999)
                                            : Color(0xFF6200EE)),
                                    onPressed: () {
                                      if (p.status == "ativo" ||
                                          p.status == "ATIVO") {
                                        if (p.estoque != null) {
                                          if (p.estoque! > 0) {
                                            int jaNoCarrinho = 0;
                                            for (var item in carrinho) {
                                              if (item.id == p.id) {
                                                jaNoCarrinho++;
                                              }
                                            }
                                            if (jaNoCarrinho < p.estoque!) {
                                              Helper.get().addCarrinho(p);
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(p.nome! +
                                                    " adicionado!"),
                                                backgroundColor:
                                                    Color(0xFF03DAC6),
                                                duration: Duration(
                                                    milliseconds: 1500),
                                              ));
                                            } else {
                                              Helper.get().mostraMsg(
                                                  context,
                                                  "Sem estoque suficiente",
                                                  true);
                                            }
                                          } else {
                                            Helper.get().mostraMsg(
                                                context, "Esgotado", true);
                                          }
                                        }
                                      } else {
                                        Helper.get().mostraMsg(context,
                                            "Produto indisponível", true);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
