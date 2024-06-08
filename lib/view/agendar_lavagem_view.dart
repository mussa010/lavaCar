import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/lavagem_controller.dart';
import 'package:lava_car/controller/login_controller.dart';
import '../controller/carro_controller.dart';
import '../controller/usuario_controller.dart';
import '../model/lavagem.dart';

class AgendarLavagem extends StatefulWidget {
  const AgendarLavagem({super.key});

  @override
  State<AgendarLavagem> createState() => _AgendarLavagem();
}

// 
// Falta criar um mapa para guardar todas informações de todos os carros;
// Quando o cliente selecionar o carro, deve-se percorrer o mapa e salvar os dados específicos do carro;
// Tmambém falta fazer a parte de edição
// 

class _AgendarLavagem extends State<AgendarLavagem> {
  var formKey = GlobalKey<FormState>();
  var txtData = TextEditingController();
  var txtHorario = TextEditingController();

  var listaCarrosCliente = [
    'Selecione'
  ];

  String nomeCliente = '', cpfCliente = '', telefoneCliente = '',  marcaCarro = '', modeloCarro = '', tipoCarro = '', valorPadraoDropDownCarro = 'Selecione', uidLavagem = '';
  var uidCliente = LoginController().idUsuarioLogado();
  bool podeApagar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final docId = ModalRoute.of(context)!.settings.arguments;
      Future<QuerySnapshot<Map<String, dynamic>>> future;
      future = CarroController().listarCarrosCliente().get();
      future.then((value) {
        dynamic doc;
        for(int i = 0; i < value.size; i++) {
          doc = value.docs[i].data();
          listaCarrosCliente.add(doc['modelo']);
        }
      });

      future = UsuarioController().listarInformacoesClienteLogado().snapshots().first;
        future.then((value) {
          dynamic doc = value.docs[0].data();
          nomeCliente = doc['nome'].toString();
          cpfCliente = doc['cpf'].toString();
          telefoneCliente = doc['telefone'].toString();
        });
      if(docId != null) {
        Future<DocumentSnapshot<Map<String, dynamic>>>futuro = LavagemController().listarLavagemEspecifica(docId);
        futuro.then((value) {
          dynamic doc = value.data();
          setState(() {
            valorPadraoDropDownCarro = doc['modeloCarro'].toString();
            txtData.text = doc['data'].toString();
            txtHorario.text = doc['horario'].toString();
            nomeCliente = doc['nomeCliente'].toString();
            cpfCliente = doc['cpfCliente'].toString();
            telefoneCliente = doc['telefoneCliente'].toString();
            marcaCarro = doc['marcaCarro'].toString();
            modeloCarro = doc['modeloCarro'].toString();
            tipoCarro = doc['tipoCarro'].toString();
            uidLavagem = doc['uidLavagem'].toString();
            // Preciso fazer a verificação da data para cancelar a lavagem ou não
            // DateTime data = DateTime.parse(txtData.text);
            // if(data.year < DateTime.now().yaer) {

            // }
          });
        });
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
          title: const Text('Agendar lavagem', style: TextStyle(color: Colors.white)),
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
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: CarroController().listarCarrosCliente().snapshots(), 
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(child: Text('Erro de conexão'));

                      case ConnectionState.waiting:
                        return  const Text('');

                      default:
                        final dados = snapshot.requireData;

                        if(dados.size == 0) {
                          return const Center(
                            child: Text(
                              'Você não possui carro cadastrado!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: txtData,
                                  enabled: true,
                                  keyboardType: TextInputType.name,
                                  decoration: const  InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: 'Data',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20)
                                      )
                                    )
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    data(context);
                                    txtData.text = 'certo';
                                  },
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
                                  controller: txtHorario,
                                  enabled: true,
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    data(context);
                                    setState(() {
                                      txtHorario.text = 'teste1';
                                    });
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    labelText: 'Horário',
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
                                    const Text('Carro:'),
                                    const SizedBox(width: 15),
                                    DropdownButton(
                                      value: valorPadraoDropDownCarro,
                                      items: listaCarrosCliente.map((String carro) {
                                        return DropdownMenuItem(
                                          value: carro,
                                          child: Text(carro),
                                        );
                                      }).toList(), 
                                      onChanged: (String? novoValor) {
                                        setState(() {
                                          valorPadraoDropDownCarro = novoValor!;
                                          if(listaCarrosCliente.contains('Selecione') && valorPadraoDropDownCarro != 'Selecione') {
                                            listaCarrosCliente.remove('Selecione');
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
                                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.blue)
                                      ),
                                      child: const Center(
                                        child: Text('Voltar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context, 'principal');
                                      },
                                    ),
                                    ElevatedButton(
                                      style:  ButtonStyle(
                                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.green)
                                      ),
                                      child: const Center(
                                        child: Text('Salvar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      
                                      onPressed: () {
                                        if(formKey.currentState!.validate()) {
                                            if(valorPadraoDropDownCarro == 'Selecione') {
                                              dialogBox(context, 'Erro', 'Selecione o veículo');
                                            } else {
                                              Future<QuerySnapshot<Map<String, dynamic>>> future = CarroController().listarCarroNomeEspecifico(valorPadraoDropDownCarro);
                                              future.then((value) {
                                                dynamic doc = value.docs.first.data();
                                                marcaCarro = doc['marca'].toString();
                                                modeloCarro = doc['modelo'].toString();
                                                tipoCarro = doc['tipoCarro'].toString();
                                                Lavagem l = Lavagem(LoginController().idUsuarioLogado(), nomeCliente, cpfCliente, telefoneCliente, marcaCarro, modeloCarro, tipoCarro, txtData.text, txtHorario.text);
                                                if(docId == null) {
                                                  LavagemController().agendarLavagem(context, l);
                                                } else {
                                                  LavagemController().editarLavagem(context, l, docId);
                                                }
                                              });
                                            }
                                        }
                                      },
                                    ),
                                  ]
                              ),
                              const SizedBox(height: 20),
                              if(docId != null) Center(child: ElevatedButton(
                                      style:  ButtonStyle(
                                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.green)
                                      ),
                                      child: const Center(
                                        child: Text('Cancelar Lavagem',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      
                                      onPressed: () {
                                        if(formKey.currentState!.validate()) {
                                            if(valorPadraoDropDownCarro == 'Selecione') {
                                              dialogBox(context, 'Erro', 'Selecione o veículo');
                                            } else {
                                              LavagemController().cancelarLavagem(context, docId);
                                            }
                                        }
                                      },
                                    )
                              ),
                              ],
                          ),
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          )
        ),
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
              elevation: MaterialStatePropertyAll(30),
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  data(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Data'),
        content: const Text('Escolha a data'),
        
        actions: [
          TextButton(
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(30),
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
}