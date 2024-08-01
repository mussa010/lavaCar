import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/login_controller.dart';
import 'package:lava_car/database/database.dart';
import 'package:lava_car/database/userLoginDAO.dart';
import 'package:lava_car/model/usuarioLogin.dart';

class CarregamentoView extends StatefulWidget {
  const CarregamentoView({super.key});

  @override
  State<CarregamentoView> createState() => _CarregamentoViewState();
}

class _CarregamentoViewState extends State<CarregamentoView> {
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
    },);
  }

  @override
  Widget build(BuildContext context) {
      return const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
  }
}
