import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../helper.dart';
import '../globals.dart';
import '../Utils.dart';
import '../colors.dart';
import 'CarrinhoScreen.dart';

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

  void filtraProdutos() {
    if (produtos == null) return;

    setState(() {
      produtosFiltrados = produtos!.where((p) {
        final nomeOk = p.nome!.toLowerCase().contains(busca.toLowerCase());
        final categoriaOk = filtro == "todos" || p.categoria == filtro;
        return nomeOk && categoriaOk;
      }).toList();
    });
  }

  void adicionaProdutoAoCarrinho(Produto p, BuildContext context) {
    if (p.status == "ativo" || p.status == "ATIVO") {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(p.nome! + " adicionado!"),
                backgroundColor: colorTeal,
                duration: Duration(milliseconds: 1500),
              ),
            );
          } else {
            Helper.get().mostraMsg(context, "Sem estoque suficiente", true);
          }
        } else {
          Helper.get().mostraMsg(context, "Esgotado", true);
        }
      }
    } else {
      Helper.get().mostraMsg(context, "Produto indisponível", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos (" + qtd.toString() + ")"),
        backgroundColor: colorPurple,
        foregroundColor: colorWhite,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => CarrinhoScreen()),
              ).then((v) {
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
                        child: Text("Tentar de novo"),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _ProdutoSearchField(
                      onChanged: (v) {
                        busca = v;
                        filtraProdutos();
                      },
                    ),
                    _CategoriaFilterChips(
                      filtroAtual: filtro,
                      onSelecionado: (valor) {
                        filtro = valor;
                        filtraProdutos();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Promoções",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          for (var p in produtos!)
                            if (p.promocao == true)
                              _ProdutoPromocaoCard(
                                produto: p,
                                onAdicionar: () {
                                  adicionaProdutoAoCarrinho(p, context);
                                },
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
                          return _ProdutoItemCard(
                            produto: p,
                            onAdicionar: () {
                              adicionaProdutoAoCarrinho(p, context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _ProdutoSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _ProdutoSearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _CategoriaFilterChips extends StatelessWidget {
  final String filtroAtual;
  final ValueChanged<String> onSelecionado;

  const _CategoriaFilterChips({
    required this.filtroAtual,
    required this.onSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    final filtros = [
      {"label": "Todos", "valor": "todos"},
      {"label": "Roupas", "valor": "roupas"},
      {"label": "Casa", "valor": "casa"},
      {"label": "Acessórios", "valor": "acessorios"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          for (var filtro in filtros)
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(filtro["label"] as String),
                selected: filtroAtual == filtro["valor"],
                onSelected: (_) {
                  onSelecionado(filtro["valor"] as String);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProdutoPromocaoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onAdicionar;

  const _ProdutoPromocaoCard({
    required this.produto,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_offer, color: colorRed),
          SizedBox(height: 4),
          Text(
            produto.nome!,
            maxLines: 2,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            Utils.formataMoeda(produto.preco * 0.85),
            style: TextStyle(
              color: colorPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onAdicionar,
            child: Text(
              "+ Adicionar",
              style: TextStyle(color: colorTeal),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProdutoItemCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onAdicionar;

  const _ProdutoItemCard({
    required this.produto,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              color: colorSoftGray,
              child: Icon(Icons.image, color: colorMediumGray),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  produto.promocao == true
                      ? Row(
                          children: [
                            Text(
                              Utils.formataMoeda(produto.preco),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: colorMediumGray,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              Utils.formataMoeda(produto.preco * 0.85),
                              style: TextStyle(
                                color: colorPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          Utils.formata(produto.getPreco()),
                          style: TextStyle(
                            color: colorPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: 4),
                  Text(
                    produto.estoque == 0 || produto.status == "esgotado"
                        ? "Esgotado"
                        : produto.estoque! < 5
                            ? "Últimas ${produto.estoque} unidades!"
                            : "Disponível",
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          produto.estoque == 0 || produto.status == "esgotado"
                              ? colorRed
                              : produto.estoque! < 5
                                  ? Colors.orange
                                  : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                color: produto.estoque == 0 ? colorMediumGray : colorPurple,
              ),
              onPressed: onAdicionar,
            ),
          ],
        ),
      ),
    );
  }
}
