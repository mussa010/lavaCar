import 'package:sqflite/sqflite.dart';

import '../model/usuarioLogin.dart';
import '../database/connection.dart';
import 'package:path/path.dart';


class UserLoginDAO {
  static Future<void> dropTableUser() async {
    await deleteDatabase(join(await getDatabasesPath(), 'Usuario.db'));
  }

  static Future<int> newUserLogin(Usuariologin u) async{
    final db = await BancoDados.abrirBanco();
    return db.insert("UserLogin", u.toJson());
  }

  Future<Usuariologin> getUserLogin(String email) async{
    final db = await BancoDados.abrirBanco();

    List<Map<String, dynamic>> map = await db.query("UserLogin", where: "email = ?", whereArgs: [email]);

    db.close();
    return Usuariologin.fromJson(map[0]);
  }
}