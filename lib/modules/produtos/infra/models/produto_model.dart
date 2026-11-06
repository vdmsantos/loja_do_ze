import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';
import 'package:loja_do_ze/modules/produtos/domain/enums/produto_status.dart';

class ProdutoModel extends Produto {
  ProdutoModel(
    super.id,
    super.nome,
    super.preco,
    super.categoria,
    super.estoque,
    super.img,
    super.promo,
    super.status,
  );

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      map['id'] as int,
      map['nome'] as String,
      (map['preco'] as num).toDouble(),
      map['categoria'] as String,
      map['estoque'] as int,
      map['imagem'] as String,
      map['promo'] as bool,
      ProdutoStatus.values.firstWhere(
        (status) => status.name == map['status'],
      ),
    );
  }
}
