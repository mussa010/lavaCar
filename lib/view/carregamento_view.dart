import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/login_controller.dart';
import 'package:lava_car/database/database.dart';
import 'package:lava_car/database/userLoginDAO.dart';
import 'package:lava_car/model/usuarioLogin.dart';
import 'package:http/http.dart' as http;

class CarregamentoView extends StatefulWidget {
  const CarregamentoView({super.key});

  @override
  State<CarregamentoView> createState() => _CarregamentoViewState();
}

class _CarregamentoViewState extends State<CarregamentoView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      entrarLoginOuPrincipal(context) ;
    },);
  }

  Future<void> _verificaBanco(context) async {
    bool verificaSeBancoExiste = await BancoDados.verificaSeBancoExiste();
    if (verificaSeBancoExiste) {
      try {
        Usuariologin user = await UserLoginDAO().getUserLogin();
        await LoginController().login(context, user.getEmail(), user.getSenha());
      } catch (e) {
        // Handle errors if necessary
        Navigator.pushReplacementNamed(context, 'login');
      }
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
    setState(() {
      isLoading = false;
    });
  }

  void entrarLoginOuPrincipal(context) {
    if (kIsWeb) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, 'login');
      });
    } else if (Platform.isAndroid) {
      _verificaBanco(context);
    }
  }

  Future<int> verificaConexaoInternet() async{
      final resposta = await http.get(Uri.parse('www.google.com.br'));
      if(resposta.statusCode == 200) {
        return 0;
      } else {
        return 1;
      }
  }


  //Mensagens Erro:
  //0 -> Conectado com sucesso
  //1-> Sem conexão com internet

  @override
  Widget build(BuildContext context) {
    String mensagem = '';
    //Ver a partir daqui
    while(true) {
      verificaConexaoInternet().then((value) {
        if(value == 0) {
          entrarLoginOuPrincipal(context);
        } else {
          setState(() {
            mensagem = 'Sem conexão com internet';
          });
        }
      },);

      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 10,),
              Text(mensagem, style: const TextStyle(color: Colors.white, fontSize: 10),)
            ],
          ),
        ),
      );  
    }
  }
}
