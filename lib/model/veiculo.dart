class Veiculo {
  String modelo;
  String cor;
  String marca;
  String motorizacao;
  String tipoCarro;
  int ano;
  String uidCliente;

  Veiculo(this.modelo, this.marca, this.ano, this.motorizacao, this.cor, this.tipoCarro,this.uidCliente);

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      json['modelo'], 
      json['marca'],
      json['ano'],
      json['motorização'],
      json['cor'],
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
      'motorização' : motorizacao,
      'cor' : cor,
      'tipoCarro': tipoCarro
    };
  }
}