
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lava_car/controller/login_controller.dart';

class LavagemController {
  // Função para agendar lavagem de cliente
  agendarLavagem(context, nomeCliente, cpfCliente, contatoCliente, uidCliente, nomeCarro, modeloCarro, tipoCarro, data, horario) {
    return FirebaseFirestore.instance.collection('agendamento');
  }

  // Função para retornar lavagem(ns) do dia do cliente
  listarLavagemDoDia() {
    final db = FirebaseFirestore.instance;
    DateTime data = DateTime.timestamp().toLocal();
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;

    // final docRef = db.collection('agendamento').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).
    // get().then((querySnapshot) {

    // }); 
    return FirebaseFirestore.instance.collection('agendamento').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado());
  }

   // Função para retornar lavagens anteriores do cliente
  listarLavanesAnteriores() {
    final db = FirebaseFirestore.instance;
    DateTime data = DateTime.timestamp().toLocal();
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;
  }

  
}