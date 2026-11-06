import 'package:flutter/foundation.dart';
import 'package:loja_do_ze/modules/produtos/domain/enums/produto_status.dart';

class Produto {
  int id;
  String nome;
  double preco;
  String? categoria;
  int estoque;
  String? img;
  bool promocao;
  ProdutoStatus status;

  Produto(this.id, this.nome, this.preco, this.categoria, this.estoque,
      this.img, this.promocao, this.status);

  // pega o preco
  double getPreco() {
    if (promocao == true) {
      return preco - (preco * 0.15);
    } else {
      return preco * 1.0;
    }
  }
}
