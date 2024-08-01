import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database/script.dart';


class BancoDados {
  //inicializar banco de dados
  static Future<Database> abrirBanco() async {
    Database db;
    var path = join(await getDatabasesPath(), 'Usuario.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute(criarTabelaUserLogin);
      },
    );
    return db;
  }

  static Future<bool> verificaSeBancoExiste() async {
    return await databaseExists(join(await getDatabasesPath(), 'Usuario.db'));
  }

  static Future<void> fecharBanco() {
    Database? db;
    return db!.close();
  }

  static Future<void> dropTableUser() async {
    await deleteDatabase(join(await getDatabasesPath(), 'Usuario.db'));
  }

  Future<bool> existenciaBanco() async{
    final path = join(await getDatabasesPath(), 'Usuario.db');
    if(await databaseExists(path)) {
      return true;
    } else {
      return false;
    }
  }
}