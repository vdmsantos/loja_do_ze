class ProdutoErro implements Exception {
  final String message;
  const ProdutoErro(this.message);

  @override
  String toString() => 'ProdutoErro: $message';
}
