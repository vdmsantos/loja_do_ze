import 'dart:convert';

import 'package:loja_do_ze/modules/produtos/domain/entities/produto.dart';
import 'package:loja_do_ze/modules/produtos/infra/datasources/produto_datasource.dart';

class ProdutoMockDatasource implements ProdutoDatasource {
  @override
  Future<List<Map<String, dynamic>>> getProdutos() async {
    try {
      String mockJson = '''
      [
        {
          "id": 1,
          "nome": "Produto 1",
          "preco": 10.0,
          "categoria": "Categoria A",
          "estoque": 5,
          "imagem": "https://example.com/produto1.jpg",
          "promo": false,
          "status": "ATIVO"
        },
        {
          "id": 2,
          "nome": "Produto 2",
          "preco": 20.0,
          "categoria": "Categoria B",
          "estoque": 3,
          "imagem": "https://example.com/produto2.jpg",
          "promo": true,
          "status": "INATIVO"
        }
      ]
      ''';
      final decodedJson = jsonDecode(mockJson) as List<dynamic>;
      return decodedJson.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception("Erro ao obter produtos: ${e.toString()}");
    }
  }

  @override
  Future<Map<String, dynamic>> adicionarProduto(Produto produto) {
    try {
      // Simula a adição do produto e retorna um mapa de sucesso
      return Future.value({
        "success": true,
        "message": "Produto adicionado com sucesso",
        "produto": {
          "id": 3,
          "nome": produto.nome,
          "preco": produto.preco,
          "categoria": produto.categoria,
          "estoque": produto.estoque,
          "imagem": produto.img,
          "promo": produto.promocao,
          "status": produto.status.name
        }
      });
    } catch (e) {
      // Em caso de erro, retorna um mapa de erro
      throw Exception("Erro ao adicionar o produto: ${e.toString()}");
    }
  }

  @override
  Future<Map<String, dynamic>> atualizarProduto(Produto produto) {
    try {
      // Simula a atualização do produto e retorna um mapa de sucesso
      return Future.value({
        "success": true,
        "message": "Produto atualizado com sucesso",
        "produto": {
          "id": produto.id,
          "nome": produto.nome,
          "preco": produto.preco,
          "categoria": produto.categoria,
          "estoque": produto.estoque,
          "imagem": produto.img,
          "promo": produto.promocao,
          "status": produto.status.name
        }
      });
    } catch (e) {
      // Em caso de erro, retorna um mapa de erro
      throw Exception("Erro ao atualizar o produto: ${e.toString()}");
    }
  }

  @override
  Future<bool> removerProduto(Produto produto) {
    try {
      // Simula a remoção do produto e retorna true
      return Future.value(true);
    } catch (e) {
      // Em caso de erro, retorna false
      throw Exception("Erro ao remover o produto: ${e.toString()}");
    }
  }
}
