import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'view/cadastro_cliente_view.dart';
import 'view/principal_view.dart';
import 'view/login_view.dart';
import 'view/sobre_aplicativo_view.dart';
import 'view/editar_conta_view.dart';
import 'view/cadastrar_carro_view.dart';


Future main() async{
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue
    )
  );
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MainApp(),
    ),
  );
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
        'principal': (context) => const PrincipalView(),
        'sobre' : (context) => const SobreAplicativo(),
        'editarConta' : (context) => const EditarConta(),
        'cadastrarCarro': (context) => const CadastrarCarro()
      }
    );
  }
}
