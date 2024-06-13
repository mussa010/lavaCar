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

  // Função para retornar lavagem(ns) do dia do cliente
   listarLavagensDoDia() {
    Future<QuerySnapshot<Map<String, dynamic>>> futuro = FirebaseFirestore.instance.collection('agendamento').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).get();
    print('certo');
    futuro.then((value) {
      Map<String,dynamic>? f;
      for(int i = 0; i < value.size; i ++) {
        dynamic doc = value.docs[i].data();

        if(DateTime.parse(doc['data'].toString()).isAfter(DateTime.now()) && DateTime.parse(doc['data'].toString()).isBefore(DateTime.now().add(const Duration(days: 1)))) {
          f!.addAll(doc);
        }
      }

      print(f.toString());
      return f;
      
    });
  }

   // Função para retornar lavagens anteriores do cliente
  listarLavanesAnteriores() {
    final db = FirebaseFirestore.instance;
    DateTime data = DateTime.now();
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;

    
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