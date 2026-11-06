import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';
import 'package:loja_do_ze/modules/produtos/infra/repositories/produto_repository.dart';

class AtualizarProdutoUseCase {
  final ProdutoRepository produtoRepository;

  AtualizarProdutoUseCase(this.produtoRepository);

  Future<Produto> chamar(Produto produto) async {
    return await produtoRepository.atualizarProduto(produto);
  }
}
