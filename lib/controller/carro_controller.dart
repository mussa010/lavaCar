import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/view/util.dart';
import '../controller/login_controller.dart';

import '../model/carro.dart';



class CarroController {
  //adicionar veículo de cliente específico
  adicionarCarroDeCliente (context, Carro c){
    return FirebaseFirestore.instance.collection('veiculo cliente').add(
      c.toJson()
    ).
    then((resultado) {
      Navigator.pushReplacementNamed(context, 'principal');
      sucesso(context, 'Veículo cadastrado com sucesso');
    });
  }

  listarCarrosCliente() {
    return FirebaseFirestore.instance.collection('veiculo cliente').
      where('uidCliente', isEqualTo: LoginController().idUsuarioLogado()).orderBy('marca');
  }

  listaCarroEspecifico(docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).snapshots().first;
  }

  listarCarroNomeEspecifico(String nome) {
    return FirebaseFirestore.instance.collection('veiculo cliente').where('modelo', isEqualTo: nome).snapshots().first;
  }

  editarCarroCliente(context, Carro c, docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).update(c.toJson()).then((value) => sucesso(context, 'Carro atualizado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível atualizar o carro'))
    .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
  }

  removerCarro(context, docId) {
    return FirebaseFirestore.instance.collection('veiculo cliente').
    doc(docId).delete().then((value) => sucesso(context, 'Carro removido com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível remover o carro'));
  }
}