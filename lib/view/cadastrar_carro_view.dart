import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/login_controller.dart';
import 'package:lava_car/model/carro.dart';
import 'package:mask/mask.dart';
import 'package:mask/mask/mask.dart';
import '../controller/carro_controller.dart';

class CadastrarCarro extends StatefulWidget {
  const CadastrarCarro({super.key});

  @override
  State<CadastrarCarro> createState() => _CadastrarCarro();
}

class _CadastrarCarro extends State<CadastrarCarro> {
  var txtAno = TextEditingController();
  var txtModeloCarro = TextEditingController();
  var txtMarca = TextEditingController();
  var txtCor = TextEditingController();
  var txtPlaca = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var tipos = [
    'Hatchback',
    'Sedan',
    'SUV',
    'Crossover',
    'Coupe',
    'Conversível',
    'Minivan',
    'Caminhonete',
    'Perua',
    'Carro Esportivo',
    'Carro de Luxo',
    'Selecione'
  ];
  

  var motorizacao = [
    'Selecione',
    '1.0',
    '1.4',
    '1.6',
    '1.8',
    '2.0',
    'Outro'
  ];

  String valorPadraoDropDownMotorizacao = 'Selecione', valorPadraoDropDownTipos = 'Selecione', motor = '', tipo = '';

  @override
  void initState() {
    super.initState();
    tipos.sort();
    motorizacao.sort();

    // Carrega dados de carro selecionado na tela principal
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final docId = ModalRoute.of(context)!.settings.arguments;

      Future<DocumentSnapshot<Object?>> future = CarroController().listaCarroEspecifico(docId);
        future.then((value) {
          dynamic doc = value.data();
          txtMarca.text = doc['marca'].toString();
          txtModeloCarro.text = doc['modelo'].toString();
          txtAno.text = doc['ano'].toString();
          txtCor.text = doc['cor'].toString();
          valorPadraoDropDownMotorizacao = doc['motorizacao'].toString();
          valorPadraoDropDownTipos = doc['tipoCarro'].toString();
        });
      
      if(docId != null) {
        if(tipos.contains('Selecione') && valorPadraoDropDownTipos != 'Selecione' && motorizacao.contains('Selecione') && valorPadraoDropDownMotorizacao != 'Selecione') {
          tipos.remove('Selecione');
          motorizacao.remove('Selecione');
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)!.settings.arguments;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'principal');
      },
      child: Scaffold(
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
        body: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: txtMarca,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null) {
                        return 'Campo vazio';
                      } else if(value.isEmpty) {
                        return 'Campo vazio';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtModeloCarro,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Modelo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null) {
                        return 'Campo vazio';
                      } else if(value.isEmpty) {
                        return 'Campo vazio';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtAno,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Ano',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null) {
                        return 'Campo vazio';
                      } else if(value.isEmpty) {
                        return 'Campo vazio';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtPlaca,
                    inputFormatters: [Mask.generic(masks: ['###-####'], hashtag: Hashtag.numbersAndLetters)],
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null) {
                        return 'Campo vazio';
                      } else if(value.isEmpty) {
                        return 'Campo vazio';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtCor,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Cor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null) {
                        return 'Campo vazio';
                      } else if(value.isEmpty) {
                        return 'Campo vazio';
                      } 
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Motorização:'),
                      const SizedBox(width: 15),
                      DropdownButton(
                        value: valorPadraoDropDownMotorizacao,
                        items: motorizacao.map((String motorizacao) {
                          return DropdownMenuItem(
                            value: motorizacao,
                            child: Text(motorizacao),
                          );
                        }).toList(), 
                        onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDownMotorizacao = novoValor!;
                            if(motorizacao.contains('Selecione') && valorPadraoDropDownMotorizacao != 'Selecione') {
                              motorizacao.remove('Selecione');
                            }
                          });
                        }
                      )
                    ]
                  ), 
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Tipo:'),
                      const SizedBox(width: 15),
                      DropdownButton(
                        value: valorPadraoDropDownTipos,
                        items: tipos.map((String tipos) {
                          return DropdownMenuItem(
                            value: tipos,
                            child: Text(tipos),
                          );
                        }).toList(), 
                        onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDownTipos = novoValor!;
                            if(tipos.contains('Selecione') && valorPadraoDropDownTipos != 'Selecione') {
                              tipos.remove('Selecione');
                            }
                          });
                        }
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style:  ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.red)
                        ),
                        child: const Center(
                          child: Text('Cancelar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'principal');
                        },
                      ),
                      ElevatedButton(
                        style:  ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.green)
                        ),
                        child: const Center(
                          child: Text('Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        
                        onPressed: () {
                          if(formKey.currentState!.validate()) {
                              Carro c = Carro(txtModeloCarro.text, txtMarca.text, int.parse(txtAno.text), txtCor.text, valorPadraoDropDownMotorizacao, txtPlaca.text, valorPadraoDropDownTipos, LoginController().idUsuarioLogado());
                              if(docId == null) {
                                if(valorPadraoDropDownMotorizacao == 'Selecione'|| valorPadraoDropDownTipos == 'Selecione') {
                                  dialogBox(context, 'Erro', 'Motorização ou tipo não selecionado');
                                } else {
                                  CarroController().adicionarCarroDeCliente(context, c);
                                }
                                
                              } else {
                                CarroController().editarCarroCliente(context, c, docId);
                              }
                          }
                        },
                      ),
                    ]
                )
                ],
          ),
            )
          )
        )
      )
    );
  }  
}

dialogBox(context, titulo, mensagem) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            style: const ButtonStyle(
              elevation: WidgetStatePropertyAll(30),
              backgroundColor: WidgetStatePropertyAll(Colors.green),
            ),
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }