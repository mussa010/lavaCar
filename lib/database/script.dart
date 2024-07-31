// Criação da table de usuário
const String criarTabelaUserLogin = '''
  CREATE TABLE IF NOT EXISTS UserLogin(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    senha TEXT NOT NULL
  ) 
''';

//Excluir tabela User
const String dropUserLogin = '''
  DROP TABLE IF EXISTS User
''';