import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../view/util.dart';
import '../model/lavagem.dart';

class LavagemController {
  // Função para agendar lavagem de cliente
  agendarLavagem(context, Lavagem l) {
    return FirebaseFirestore.instance.collection('agendamento').add(
      l.toJson()
    ).
    then((resultado) {
      Navigator.pushReplacementNamed(context, 'principal');
      sucesso(context, 'Agendamento realizado com sucesso');
    });
  }

  listarTodasAsLavagens() {
    return FirebaseFirestore.instance.collection('agendamento').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).orderBy('data').snapshots();
    
  }

  listarLavagemEspecifica(docId) {
    return FirebaseFirestore.instance.collection('agendamento').doc(docId).snapshots().first;
  }

  editarLavagem(context, Lavagem l, docId) {
    return FirebaseFirestore.instance.collection('agendamento').
    doc(docId).update(l.toJson()).then((value) => sucesso(context, 'Agendamento atualizado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível atualizar o agendamento'))
    .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
  }

  cancelarLavagem(context, docId) {
    return FirebaseFirestore.instance.collection('agendamento').
    doc(docId).delete().then((value) => sucesso(context, 'Lavagem cancelada com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível cancelar a lavage'))
    .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
  }
}