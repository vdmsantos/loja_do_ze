import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loja_do_ze/modules/produtos/infra/models/produto_model.dart';
import 'modules/produtos/domain/entities/produto.dart';
import 'globals.dart';
import 'shared/utils/Utils.dart';

// classe que faz as coisas
class Helper {
  static Helper? _i;
  static Helper get() {
    if (_i == null) _i = Helper();
    return _i!;
  }

  // pega os produtos da api
  Future<List<Produto>?> getProdutos() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      // simula a api caindo as vezes
      if (Random().nextInt(10) == 7) throw Exception("erro");
      var json = '''
      [
        {"id": 1, "nome": "Camiseta Dev", "preco": 59.9, "categoria": "roupas", "estoque": 10, "imagem": "", "promo": false},
        {"id": 2, "nome": "Caneca Flutter", "preco": 35, "categoria": "casa", "estoque": 3, "imagem": "", "promo": true},
        {"id": "3", "nome": "Moletom Dart", "preco": 189.9, "categoria": "roupas", "estoque": 0, "imagem": "", "promo": false, "status": "esgotado"},
        {"id": 4, "nome": "Adesivo Widget", "preco": 9.9, "categoria": "acessorios", "estoque": 100, "imagem": "", "promo": true},
        {"id": 5, "nome": "Mousepad Clean Code", "preco": 79.9, "categoria": "acessorios", "estoque": 4, "imagem": "", "promo": false, "status": "ATIVO"},
        {"id": 6, "nome": "Almofada Hot Reload", "preco": 120, "categoria": "casa", "estoque": 7, "imagem": "", "promo": true},
        {"id": 7, "nome": "Bone Null Safety", "preco": 49.9, "categoria": "roupas", "estoque": 2, "imagem": "", "promo": false, "status": "inativo"}
      ]
      ''';
      var lista = jsonDecode(json);
      List<Produto> l = [];
      for (var i = 0; i < lista.length; i++) {
        l.add(ProdutoModel.fromMap(lista[i]));
      }
      return l;
    } catch (e) {
      print(e);
      return null;
    }
  }

  bool login(String u, String s) {
    if (u == "admin" && s == SENHA_ADMIN) {
      usuarioLogado = "admin";
      return true;
    } else if (u.length > 3 && s.length >= 6) {
      usuarioLogado = u;
      return true;
    }
    return false;
  }

  // calcula
  double calcula(List<Produto> l, bool c, bool f, String? uf) {
    double t = 0;
    for (var p in l) {
      t = t + p.getPreco();
    }
    if (c == true) {
      if (t > 100) {
        if (usuarioLogado != null) {
          if (usuarioLogado == "admin") {
            t = t * 0.7;
          } else {
            t = t * 0.9;
          }
        } else {
          t = t * 0.95;
        }
      }
    }
    if (f == true) {
      if (uf == "SC" || uf == "PR" || uf == "RS") {
        t = t + 15;
      } else if (uf == "SP" || uf == "RJ") {
        t = t + 20;
      } else {
        if (t < 200) {
          t = t + 35.5;
        }
      }
    }
    return t;
  }

  void addCarrinho(Produto p) {
    carrinho.add(p);
    total = total + p.getPreco();
    qtd++;
    flag = true;
  }

  void removeCarrinho(int index) {
    try {
      total = total - carrinho[index].getPreco();
      carrinho.removeAt(index);
      qtd--;
    } catch (e) {}
  }

  void mostraMsg(BuildContext context, String msg, bool erro) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: erro == true ? Color(0xFFB00020) : Color(0xFF03DAC6),
      duration: Duration(milliseconds: 1500),
    ));
  }

  // TODO: arrumar isso depois (2019)
  int validaTudo(String nome, String email, String cpf) {
    if (nome == "") return -1;
    if (!Utils.validaEmail(email, 1)) return -2;
    if (!Utils.validaEmail(cpf, 3)) return -3;
    return 1;
  }
}
