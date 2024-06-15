class CarroFipe {
  final String preco;
  final String marca;
  final String modelo;
  final int ano;
  final String combustivel;

  CarroFipe(this.marca, this.modelo, this.ano, this.combustivel, this.preco);

  factory CarroFipe.fromJson(Map json) {
    return CarroFipe(
      json['brand'],
      json['model'], 
      json['modelYear'], 
      json['fuel'], 
      json['price']);
  }
}