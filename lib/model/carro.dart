class Carro {
  String modelo;
  String cor;
  String marca;
  int ano;
  String tipoCarro;
  String motorizacao;
  String uidCliente;
  String placa;
  String codigoFipe;

  Carro(this.modelo, this.marca, this.ano, this.cor, this.motorizacao, this.placa, this.codigoFipe, this.tipoCarro,this.uidCliente);

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      json['modelo'], 
      json['marca'],
      json['ano'],
      json['cor'],
      json['motorizacao'],
      json['tipoCarro'],
      json['placa'],
      json['codigoFipe'],
      json['uidCliente']
    );
  }

  Map<String, dynamic> toJson() {
    return <String,dynamic> {
      'uidCliente' : uidCliente,
      'modelo' : modelo,
      'marca' : marca,
      'ano' : ano,
      'cor' : cor,
      'motorizacao' : motorizacao,
      'tipoCarro' : tipoCarro,
      'codigoFipe' : codigoFipe,
      'placa' : placa
    };
  }
}