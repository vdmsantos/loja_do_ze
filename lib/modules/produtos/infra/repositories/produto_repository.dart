import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';

abstract interface class ProdutoRepository {
  Future<List<Produto>> getProdutos();
  Future<Produto> adicionarProduto(Produto produto);
  Future<Produto> atualizarProduto(Produto produto);
  Future<bool> removerProduto(Produto produto);
}
