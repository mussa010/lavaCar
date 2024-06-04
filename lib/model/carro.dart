class Carro {
  String modelo;
  String cor;
  String marca;
  int ano;
  String tipoCarro;
  String motorizacao;
  String uidCliente;

  Carro(this.modelo, this.marca, this.ano, this.cor, this.motorizacao, this.tipoCarro,this.uidCliente);

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      json['modelo'], 
      json['marca'],
      json['ano'],
      json['cor'],
      json['motorizacao'],
      json['tipoCarro'],
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
      'tipoCarro' : tipoCarro
    };
  }

  String getModelo() {
    return modelo;
  }

  String getCor() {
    return cor;
  }

  String getMarca() {
    return marca;
  }

  String getAno() {
    return ano.toString();
  }

  String getMotorizacao() {
    return motorizacao;
  }

  String getTipoCarro() {
    return tipoCarro;
  }
}