import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/view/util.dart';
import '../controller/login_controller.dart';

import '../model/veiculo.dart';



class CarroController {
  //adicionar veículo de cliente específico
  adicionarCarroDeCliente (context, Veiculo v){
    return FirebaseFirestore.instance.collection('veiculo cliente').add(
      v.toJson()
    ).
    then((resultado) {
      Navigator.pushReplacementNamed(context, 'principal');
      sucesso(context, 'Veículo cadastrado com sucesso');
    });
  }

  listarCarrosCliente() {
    return FirebaseFirestore.instance.collection('veiculo cliente').
      where('uidCliente', isEqualTo: LoginController().idUsuarioLogado());
  }

  listaCarroEspecifico(docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).snapshots().first;
  }

  editarCarroCliente(context, Veiculo v, docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).update(v.toJson()).then((value) => sucesso(context, 'Carro atualizado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível atualizar o carro'))
    .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
  }

  removerCarro(context, docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).delete().then((value) => sucesso(context, 'Carro removido com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível remover o carro'));
  }
}