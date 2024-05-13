class Agendamento {
  final String uid;
  final String nomeCliente;
  final String cpfCliente;
  final String tipoCarro;

  Agendamento(this.uid, this.nomeCliente, this.cpfCliente, this.tipoCarro);

  // Transforma objeto em Json
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'uid': uid,
      'Nome do cliente': nomeCliente,
      'CPF do cliente': cpfCliente,
      'Tipo do carro': tipoCarro
    };
  }

  // Transforma Json em objeto
  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      json['uid'],
      json['Nome do cliente'],
      json['CPF do cliente'],
      json['Tipo do carro']
    );
  }
}