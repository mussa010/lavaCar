import '../model/usuarioLogin.dart';
import 'package:sqflite/sqflite.dart';
import '../database/script.dart';
import '../database/connection.dart';


class UserLoginDAO {
  static Future<void> dropTableUser() async {
    final db = await Connection.get();
    await db.execute(dropUserLogin);
  }

  static Future<int> newUserLogin(Usuariologin u) async{
    final db = await Connection.get();
    return db.insert("UserLogin", u.toJson());
  }

  Future<Usuariologin> getUserLogin(String email) async{
    final db = await Connection.get();

    List<Map<String, dynamic>> map = await db.query("UserLogin", where: "email = ?", whereArgs: [email]);

    db.close();
    return Usuariologin.fromJson(map[0]);
  }
}