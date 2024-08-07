import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lava_car/view/cadastrar_endereco_view.dart';

import 'firebase_options.dart';
import '../view/cadastro_cliente_view.dart';
import '../view/principal_view.dart';
import '../view/login_view.dart';
import '../view/sobre_aplicativo_view.dart';
import '../view/cadastrar_carro_view.dart';
import '../view/agendar_lavagem_view.dart';
import '../view/pesquisar_view.dart';
import 'view/carregamento_view.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized(); 

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  );

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
      initialRoute: 'carregamento',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt', 'BR')
      ],
      routes: {
        'carregamento' : (context) => const CarregamentoView(),
        'login': (context) => const LoginView(),
        'cadastrar': (context) => const CadastrarCliente(),
        'principal': (context) => const PrincipalView(),
        'sobre' : (context) => const SobreAplicativo(),
        'cadastrarCarro': (context) => const CadastrarCarro(),
        'agendarlavagem' : (context) => const AgendarLavagem(),
        'pesquisar' : (context) => const Pesquisar(),
        'endereço' : (context) => const CadastrarEndereco()
      }
    );
  }
}
