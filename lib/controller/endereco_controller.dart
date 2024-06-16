import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/model/endereco.dart';

import '../view/cadastrar_endereco_view.dart';
import '../controller/login_controller.dart';
import '../view/util.dart';

class EnderecoController {
  cadastroEndereco(context, Endereco e) {
    return FirebaseFirestore.instance.collection('endereco').add(
      e.toJson()
    ).
    then((resultado) {
      Navigator.pushReplacementNamed(context, 'principal');
      sucesso(context, 'Endereço cadastrado com sucesso');
    });
  }

  editarEndereco(context, Endereco e) {
    Future<QuerySnapshot<Map<String, dynamic>>> future = FirebaseFirestore.instance.collection('endereco').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).snapshots().first;

    future.then(
      (value) {
        String id = value.docs[0].id;
        print(id);

        return FirebaseFirestore.instance.collection('endereco').
          doc(id).update(e.toJson()).then((value) => sucesso(context, 'Endereço atualizado com sucesso'))
          .catchError((e) => erro(context, 'Não foi possível atualizar o endereço'))
          .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
      },
    );
  }

  apagarEndereco(context) {
    Future<QuerySnapshot<Map<String, dynamic>>> future = FirebaseFirestore.instance.collection('endereco').where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).snapshots().first;

    future.then(
      (value) {
        String id = value.docs[0].id;
        print(id);

        return FirebaseFirestore.instance.collection('endereco').
          doc(id).delete().then((value) => sucesso(context, 'Endereço apagado com sucesso'))
          .catchError((e) => erro(context, 'Não foi possível apagar o endereço'))
          .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
      },
    );
  }

  listarEndereco() {
    return FirebaseFirestore.instance.collection('endereco').
      where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).snapshots().first;
  }
}