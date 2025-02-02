import 'package:flutter/material.dart';

class SobreAplicativo extends StatefulWidget {
  const SobreAplicativo({super.key});

  @override
  State<SobreAplicativo> createState() => _SobreAplicativo();
}

class _SobreAplicativo extends State<SobreAplicativo> {
  @override
  Widget build(BuildContext context) {
    const  String about = '''
      Nome do Criador:\nMatheus Teixeira Mussalam\n\nCódigo:\n836445\n\nTema escolhido:\nLava rápido\n\nObjetivo:\nTem como objetivo possibilitar que o usuário salve as informações de seu(s) carro(s), agende uma lavagem, consulte a tabela FIPE do seu veículo, visualize o histórico de lavagens e pesquise sobre seu veículo.
    ''';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
          Navigator.pushReplacementNamed(context, 'principal');
        },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
            title: const Text(
              'Sobre o aplicativo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'principal');
              },
            ),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.01,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
                  ),
                ), 
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                    child: const Text(about,textAlign: TextAlign.center),
                  ),
                ),
              ],
            )
          )
        )
      );
  }
}