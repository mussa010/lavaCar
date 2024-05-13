import 'package:flutter/material.dart';
import 'package:lava_car/view/cadastro_cliente_view.dart';
import 'package:lava_car/view/principal_view.dart';

import 'view/login_view.dart';

Future main() async{
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastrar': (context) => const CadastrarView(),
        'principal': (context) => const PrincipalView()
      }
    );
  }
}
