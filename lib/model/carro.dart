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
  String modeloPesquisa;

  Carro(this.modelo, this.modeloPesquisa, this.marca, this.ano, this.cor, this.motorizacao, this.placa, this.codigoFipe, this.tipoCarro,this.uidCliente);

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      json['modelo'], 
      json['modeloPesquisa'],
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
      'modeloPesquisa' : modeloPesquisa,
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