import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/database/database.dart';

import '../view/util.dart';
import '../database/userLoginDAO.dart';
import '../model/usuarioLogin.dart';

class LoginController {
  // 
  // Criar conta de um cliente
  // 

  criarConta(context, nome, email, senha, dataNascimento, cpf, genero, telefone) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: senha,
    ).then(
      (resultado) {
        //Usuário criado com sucesso!

        //Armazenar o NOME e UID do usuário no Firestore
        FirebaseFirestore.instance.collection("cliente").add(
          {
            "uid": resultado.user!.uid,
            "nome": nome,
            "dataNascimento": dataNascimento,
            "cpf": cpf,
            "genero": genero,
            "telefone": telefone,
            "funcionario": false,
            "email": email,
          },
        );

        sucesso(context, 'Cliente criado com sucesso!');
        Navigator.pushReplacementNamed(context, 'login');
      },
    ).catchError((e) {
      //Erro durante a criação do cliente
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        case 'invalid-email':
          erro(context, 'O formato do e-mail é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.toString()}');
      }
    });
  }

  login(context, email, senha) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha)
    .then((resultado) {
      Usuariologin u = Usuariologin(email, senha);
      UserLoginDAO.newUserLogin(u);
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'O formato do e-mail é inválido.');
        case 'invalid-credential':
          erro(context, 'Usuário e/ou senha inválida.');
        case 'network-request-failed':
          erro(context, 'Sem conexão com a internet');
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  esqueceuSenha(context, email) {
    if (email.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      sucesso(context, 'Email enviado com sucesso.');
    } else {
      erro(context, 'Informe o email para recuperar a conta.');
    }
  }
  
  // 
  // Efetuar Logout do usuário
  // 
  logout() {
    BancoDados.dropTableUser();
    FirebaseAuth.instance.signOut();
  }

  //
  // Retornar o UID (User Identifier) do usuário que está logado no App
  //
  idUsuarioLogado() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

}