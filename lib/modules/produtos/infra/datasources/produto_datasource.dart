import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';

abstract interface class ProdutoDatasource {
  Future<List<Map<String, dynamic>>> getProdutos();
  Future<Map<String, dynamic>> adicionarProduto(Produto produto);
  Future<Map<String, dynamic>> atualizarProduto(Produto produto);
  Future<bool> removerProduto(Produto produto);
}
