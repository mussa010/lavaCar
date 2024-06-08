import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

import '../model/usuario.dart';
import '../view/util.dart';

class UsuarioController {
  // Retorna informações do cliente logado
  listarInformacoesClienteLogado() {
    return FirebaseFirestore.instance.collection('cliente').
      where('uid',isEqualTo: LoginController().idUsuarioLogado());
  }

  editarInformacoesCliente(context, Usuario u, docId) {
    return FirebaseFirestore.instance.collection('cliente').
    doc(docId).update(u.toJson()).then((value) => sucesso(context, 'Usuário atualizado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível atualizar o usuário'))
    .whenComplete(() => Navigator.pushReplacementNamed(context, 'principal'));
  }
}