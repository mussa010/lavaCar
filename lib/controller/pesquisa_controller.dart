import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lava_car/controller/login_controller.dart';

class PesquisaController {

  pesquisarCarro(context, String carro) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    where('uidCliente', isEqualTo: LoginController().idUsuarioLogado())
    .where('modelo', isGreaterThanOrEqualTo: carro).snapshots().first;
  }
}