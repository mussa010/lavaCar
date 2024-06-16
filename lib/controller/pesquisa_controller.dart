import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lava_car/controller/login_controller.dart';


class PesquisaController {

  pesquisarCarro(context, String carro) {
    return FirebaseFirestore.instance.collection('veiculo cliente')
    .where('uidCliente', isEqualTo: LoginController().idUsuarioLogado())
    .where('modeloPesquisa', isEqualTo: carro).snapshots();
  }

  pesquisarLavagensDoVeiculo(context, String carro, String ordem) {
    if(ordem == 'Relevância') {
      return FirebaseFirestore.instance.collection('agendamento').
        where('uidCliente', isEqualTo: LoginController().idUsuarioLogado())
        .where('modeloCarroPesquisa', isEqualTo: carro).snapshots();
    } else if(ordem == 'Data crescente'){
      return FirebaseFirestore.instance.collection('agendamento').
        where('uidCliente', isEqualTo: LoginController().idUsuarioLogado())
        .where('modeloCarroPesquisa', isEqualTo: carro).orderBy('data').snapshots();
    } else {
      return FirebaseFirestore.instance.collection('agendamento').
        where('uidCliente', isEqualTo: LoginController().idUsuarioLogado())
        .where('modeloCarroPesquisa', isEqualTo: carro).orderBy('data',descending: true).snapshots();
    }
  }
}