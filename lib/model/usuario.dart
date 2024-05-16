class Usuario {
  final String nome;
  final String email;

  Usuario(this.nome, this.email);

  factory Usuario.fromJson (Map<String, dynamic> json){
    return Usuario(
      json["nome"],
      json["email"]
    );
  }

  String getNome() {
    return this.nome;
  }

  String getEmail() {
    return this.email;
  }
}