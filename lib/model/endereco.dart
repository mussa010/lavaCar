class Endereco {
  String endereco;
  int numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;
  String uidCliente;

  Endereco(this.endereco, this.numero, this.bairro, this.complemento, this.cep, this.cidade, this.estado, this.uidCliente);

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      json['endereco'], 
      json['numero'],
      json['bairro'],
      json['complemento'],
      json['cep'],
      json['cidade'],
      json['estado'],
      json['uidCliente']
    );
  }

  Map<String, dynamic> toJson() {
    return <String,dynamic> {
      'endereco' : endereco,
      'numero' : numero,
      'bairro' : bairro,
      'complemento' : complemento,
      'cep' : cep,
      'cidade' : cidade,
      'estado' : estado,
      'uidCliente' : uidCliente
    };
  }
}