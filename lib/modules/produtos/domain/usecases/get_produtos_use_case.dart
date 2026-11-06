import 'package:loja_do_ze/modules/produtos/infra/repositories/produto_repository.dart';

class GetProdutosUseCase {
  final ProdutoRepository produtoRepository;

  GetProdutosUseCase(this.produtoRepository);

  Future<List> chamar() async {
    return await produtoRepository.getProdutos();
  }
}
