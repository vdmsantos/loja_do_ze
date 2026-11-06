import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';
import 'package:loja_do_ze/modules/produtos/infra/repositories/produto_repository.dart';

class RemoverProdutoUseCase {
  final ProdutoRepository produtoRepository;

  RemoverProdutoUseCase(this.produtoRepository);

  Future<bool> chamar(Produto produto) async {
    return await produtoRepository.removerProduto(produto);
  }
}
