
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lava_car/controller/login_controller.dart';

class LavagemController {

  listarLavagensCliente() {
    final db = FirebaseFirestore.instance;
    DateTime data = DateTime.timestamp().toLocal();

    final docRef = db.collection('agendamento').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).
    get().then((querySnapshot) {
      for(var docSnapshot in querySnapshot.docs) {

      }
    }); 

    
  }
}