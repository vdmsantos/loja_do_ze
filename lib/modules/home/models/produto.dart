class Produto {
  int id;
  String? nome;
  double preco;
  String? categoria; 
  int? estoque;
  String? urlImagem;
  bool? desconto;
  String status = "ativo"; // ativo, inativo, esgotado, ATIVO

  Produto(this.id, this.nome, this.preco, this.categoria, this.estoque, this.urlImagem,
      this.desconto);

  // cria produto a partir do map
  static Produto fromMap(Map map) {
    var item = Produto(map['id'], map['nome'], map['preco'], map['categoria'],
        map['estoque'], map['urlImagem'], map['desconto']);
    if (map['status'] != null) item.status = map['status'];
    return item;
  }

  // pega o preco
  double getPreco() {
    if (desconto == true) {
      return preco - (preco * 0.15);
    } else {
      return preco * 1.0;
    }
  }
}
