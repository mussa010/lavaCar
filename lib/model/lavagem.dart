class Lavagem {
  final String nomeCliente;
  final String cpfCliente;
  final String uidCliente;
  final String telefoneCliente;
  final String marcaCarro;
  final String tipoCarro;
  final String modeloCarro;
  final String data;
  final String horario;

  Lavagem(this.uidCliente, this.nomeCliente, this.cpfCliente, this.telefoneCliente, this.marcaCarro, this.modeloCarro,this.tipoCarro, this.data, this.horario);

  // Transforma objeto em Json
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'uidCliente': uidCliente,
      'nomeCliente': nomeCliente,
      'cpfCliente': cpfCliente,
      'telefoneCliente': telefoneCliente,
      'marcaCarro' : marcaCarro,
      'tipoCarro': tipoCarro,
      'modeloCarro' : modeloCarro,
      'data': data,
      'horario' : horario
    };
  }

  // Transforma Json em objeto
  factory Lavagem.fromJson(Map<String, dynamic> json) {
    return Lavagem(
      json['uidCliente'],
      json['nomeCliente'],
      json['cpfCliente'],
      json['telefoneCliente'],
      json['marcaCarro'],
      json['tipoCarro'],
      json['modeloCarro'],
      json['data'],
      json['horario']
    );
  }
}