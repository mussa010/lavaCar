import 'package:flutter/material.dart';

class CadastrarCarro extends StatefulWidget {
  const CadastrarCarro({super.key});

  @override
  State<CadastrarCarro> createState() => _CadastrarCarro();
}

class _CadastrarCarro extends State<CadastrarCarro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar carro', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded) ,
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'principal');
          },
          color: Colors.white,
        ), 
      ),
    );
  }
}