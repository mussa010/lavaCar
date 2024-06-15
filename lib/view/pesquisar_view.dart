import 'package:flutter/material.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _Pesquisar();
}

class _Pesquisar extends State<Pesquisar> {
  var txtPesquisa = TextEditingController();

  var opcoesPesquisa = [
    'Carro',
    'Lavagens por veículo',

  ];

  var ordem = [
    'Crescente', 
    'Decrescente',
    
  ];

  @override
  Widget build(BuildContext context) {
    String pesquisa;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle:  true,
        title: const Text(
          'Pesquisa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, 'principal'),
        ),
        actions: [
            IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              if(txtPesquisa.text.isEmpty) {
                dialogBox(context, 'Aviso', 'Campo de pesquisa está vazio');
              } else {
                setState(() {
                  // Função para pesquisar dependendo do que foi selecionado
                });
              }
            }
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'principal');
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(

            ),
          ),
        ),
      ),
    );
  }
}

dialogBox(context, titulo, mensagem) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'voltar'),
            child: const Text('voltar'),
          ),
        ],
      ),
    );
  }