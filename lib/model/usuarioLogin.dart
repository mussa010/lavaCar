class Usuariologin {
  final String _email;
  final String _senha;

  Usuariologin(this._email, this._senha);

  factory Usuariologin.fromJson (Map<String, dynamic> json){
    return Usuariologin(
      json["email"],
      json["senha"]
    );
  }

  // Transforma objeto em Json
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'email': _email,
      'senha': _senha,
    };
  }

  String getEmail() {
    return this._email;
  }

  String getSenha() {
    return this._senha;
  }
}