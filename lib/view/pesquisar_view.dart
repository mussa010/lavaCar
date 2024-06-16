import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/carro_controller.dart';
import '../controller/pesquisa_controller.dart';

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

  var ordemPesquisa = [
    'Relevância',
    'Data crescente',
    'Data decrescente'
  ];

  String valorPadraoDropDownOpcoesPesquisa = 'Veículo', valorPadraoDropDownOrdemPesquisa = 'Relevância';

  bool veiculosPodemAparecer = false, lavagensPodemAparecer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.black,
                          onPressed: () {
                            if (txtPesquisa.text.isEmpty) {
                              dialogBox(context, 'Aviso', 'Campo de pesquisa está vazio');
                            } else {
                              setState(() {
                                if (valorPadraoDropDownOpcoesPesquisa == 'Veículo') {
                                  veiculosPodemAparecer = true;
                                } else {
                                  lavagensPodemAparecer = true;
                                }
                              });
                            }
                          },
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Pesquisar por:'),
                    const SizedBox(width: 15),
                    DropdownButton(
                        value: valorPadraoDropDownOpcoesPesquisa,
                        items: opcoesPesquisa.map((String pesquisa) {
                          return DropdownMenuItem(
                            value: pesquisa,
                            child: Text(pesquisa),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDownOpcoesPesquisa = novoValor!;
                          });
                        })
                  ],
                ),
                const SizedBox(height: 20),
                if(valorPadraoDropDownOpcoesPesquisa != 'Veículo') Row(
                  children: [
                    const Text('Classificar por:'),
                    const SizedBox(width: 15),
                    DropdownButton(
                        value: valorPadraoDropDownOrdemPesquisa,
                        items: ordemPesquisa.map((String ordem) {
                          return DropdownMenuItem(
                            value: ordem,
                            child: Text(ordem),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDownOrdemPesquisa = novoValor!;
                          });
                        })
                  ],
                ),
                if(valorPadraoDropDownOpcoesPesquisa != 'Veículo') const SizedBox(height: 20),
                if(valorPadraoDropDownOpcoesPesquisa == 'Veículo') if(veiculosPodemAparecer == true) if(txtPesquisa.text != '') StreamBuilder<QuerySnapshot>
                (
                  stream: PesquisaController().pesquisarCarro(context, txtPesquisa.text.toUpperCase()), 
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(child: Text('Erro de conexão'));
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator(color: Colors.black);
                      default:
                        final dados = snapshot.requireData;
                        if (dados.size > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: dados.size,
                              itemBuilder: (context, index) {
                                String id = dados.docs[index].id;
                                dynamic doc = dados.docs[index].data();
                                return Card(
                                  color: const Color.fromARGB(255, 0, 110, 255),
                                  child: ListTile(
                                    title: Text(doc['marca'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    subtitle: Text('Modelo: ${doc['modelo']}\nAno: ${doc['ano']}\nCor: ${doc['cor']}\nMotorização: ${doc['motorizacao']}\nTipo: ${doc['tipoCarro']}\nPlaca: ${doc['placa']}\nCódigo FIPE: ${doc['codigoFipe']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'cadastrarCarro', arguments: id);
                                            }, 
                                            icon: const Icon(Icons.mode_edit_outlined, color: Colors.white,)
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              CarroController().removerCarro(context, id);
                                            }, 
                                            icon: const Icon(Icons.delete_outline_outlined, color: Colors.white,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                        } else {
                          return const Center(
                            child: Text(
                              'Não há carro cadastrado',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                    }
                  },
                ),
                if(valorPadraoDropDownOpcoesPesquisa != 'Veículo') if(lavagensPodemAparecer == true) if(txtPesquisa.text != '') StreamBuilder<QuerySnapshot>(
                  stream: PesquisaController().pesquisarLavagensDoVeiculo(context, txtPesquisa.text.toUpperCase(), valorPadraoDropDownOrdemPesquisa),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(child: Text('Erro de conexão'));
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator(color: Colors.black);
                      default:
                        final dados = snapshot.requireData;
                        if (dados.size > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: dados.size,
                              itemBuilder: (context, index) {
                                String id = dados.docs[index].id;
                                dynamic doc = dados.docs[index].data();
                                DateTime data = DateTime.parse(doc['data']);
                                
                                return Card(
                                  color: const Color.fromARGB(255, 0, 110, 255),
                                  child: ListTile(
                                    subtitle: Text( data.month < 10 ? 
                                      'Data: ${data.day}/0${data.month}/${data.year}\nHorário: ${doc['horario']}\nMarca do carro: ${doc['marcaCarro']}\nModelo do carro: ${doc['modeloCarro']}\nTipo do carro: ${doc['tipoCarro']}\nPlaca do carro: ${doc['placaCarro']}'
                                      : 'Data: ${data.day}/${data.month}/${data.year}\nHorário: ${doc['horario']}\nMarca do carro: ${doc['marcaCarro']}\nModelo do carro: ${doc['modeloCarro']}\nTipo do carro: ${doc['tipoCarro']}\nPlaca do carro: ${doc['placaCarro']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'agendarlavagem', arguments: id);
                                            }, 
                                            icon: const Icon(Icons.mode_edit_outlined, color: Colors.white,)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                        } else {
                          return const Center(
                            child: Text(
                              'Não há lavagem',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                    }
                  },
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
