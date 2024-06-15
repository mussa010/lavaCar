import 'package:flutter/material.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({super.key});

  @override
  State<Pesquisar> createState() => _Pesquisar();
}

class _Pesquisar extends State<Pesquisar> {
  var txtPesquisa = TextEditingController();

  var opcoesPesquisa = [
    'Veículo',
    'Lavagens do veículo',
  ];

  String valorPadraoDropDownTipos = 'Veículo';

  @override
  Widget build(BuildContext context) {
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
              children: [
                TextFormField(
                  controller: txtPesquisa,
                  decoration:  InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.black,
                        onPressed: () {
                          if(txtPesquisa.text.isEmpty) {
                            dialogBox(context, 'Aviso', 'Campo de pesquisa está vazio');
                          } else {
                            setState(() {
                              // Função para pesquisar dependendo do que foi selecionado
                            });
                          }
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      ))
                ),
                Row(
                  children: [
                    const Text('Pesquisar por:'),
                      const SizedBox(width: 15),
                      DropdownButton(
                        value: valorPadraoDropDownTipos,
                        items: opcoesPesquisa.map((String pesquisa) {
                          return DropdownMenuItem(
                            value: pesquisa,
                            child: Text(pesquisa),
                          );
                        }).toList(), 
                        onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDownTipos = novoValor!;
                          });
                        }
                      )
                  ],
                )

              ],
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