import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database/script.dart';

class Connection {
  Connection._();

  //inicializar banco de dados
  static Future<Database> get() async {
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
}