import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

import '../view/util.dart';

class UsuarioController {
  // Retorna informações do cliente logado
  listarInformacoesClienteLogado() {
    return FirebaseFirestore.instance.collection('cliente').
      where('uid',isEqualTo: LoginController().idUsuarioLogado());
  }
}