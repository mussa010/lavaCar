import 'package:sqflite/sqflite.dart';

import '../model/usuarioLogin.dart';
import '../database/database.dart';
import 'package:path/path.dart';


class UserLoginDAO {
  static Future<int> newUserLogin(Usuariologin u) async{
    final db = await BancoDados.abrirBanco();
    return db.insert("UserLogin", u.toJson());
  }

  Future<Usuariologin> getUserLogin() async{
    final db = await BancoDados.abrirBanco();

    List<Map<String, dynamic>> map = await db.query("UserLogin");

    db.close();
    return Usuariologin.fromJson(map[0]);
  }
}