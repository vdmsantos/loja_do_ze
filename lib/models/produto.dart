class Produto {
  var id;
  String? nome;
  var preco;
  String? categoria;
  int? estoque;
  String? imagem;
  bool? promocao;
  String status = "ativo"; // ativo, inativo, esgotado, ATIVO

  Produto(this.id, this.nome, this.preco, this.categoria, this.estoque,
      this.imagem, this.promocao);

  // cria produto a partir do map
  static Produto fromMap(Map m) {
    var p = Produto(m['id'], m['nome'], m['preco'], m['categoria'],
        m['estoque'], m['imagem'], m['promo']);
    if (m['status'] != null) p.status = m['status'];
    return p;
  }

  // pega o preco
  double getPreco() {
    if (promocao == true) {
      return preco - (preco * 0.15);
    } else {
      return preco * 1.0;
    }
  }
}
