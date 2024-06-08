class Usuario {
  final String nome;
  final String data;
  final String cpf;
  final String genero;
  final String telefone;

  Usuario(this.nome, this.data, this.cpf, this.genero, this.telefone);

  factory Usuario.fromJson (Map<String, dynamic> json){
    return Usuario(
      json["nome"],
      json["dataNascimento"],
      json["cpf"],
      json["genero"],
      json["telefone"],
    );
  }

  // Transforma objeto em Json
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'nome': nome,
      'dataNascimento': data,
      'cpf': cpf,
      'genero': genero,
      'telefone' : telefone
    };
  }
}