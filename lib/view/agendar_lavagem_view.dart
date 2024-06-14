import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_file.dart';
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


class _AgendarLavagem extends State<AgendarLavagem> {
  var formKey = GlobalKey<FormState>();
  var txtData = TextEditingController();
  var txtHorario = TextEditingController();

  var listaCarrosCliente = [
    'Selecione'
  ];

  String nomeCliente = '', cpfCliente = '', telefoneCliente = '',  marcaCarro = '', modeloCarro = '', tipoCarro = '', valorPadraoDropDownCarro = 'Selecione', uidLavagem = '';
  var uidCliente = LoginController().idUsuarioLogado();
  bool podeCancelar = true;
  DateTime data = DateTime.now();
  TimeOfDay horarioSelecionado = TimeOfDay.now();

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
            nomeCliente = doc['nomeCliente'].toString();
            cpfCliente = doc['cpfCliente'].toString();
            telefoneCliente = doc['telefoneCliente'].toString();
            marcaCarro = doc['marcaCarro'].toString();
            modeloCarro = doc['modeloCarro'].toString();
            tipoCarro = doc['tipoCarro'].toString();
            uidLavagem = doc['uidLavagem'].toString();
            data = DateTime.parse(doc['data'.toString()]);
            if(data.month < 10) {
              txtData.text = '${data.day}/0${data.month}/${data.year}';
            } else {
              txtData.text = '${data.day}/${data.month}/${data.year}';
            }

            horarioSelecionado = TimeOfDay(hour: int.parse(doc['horario'].toString().split(":")[0]), minute: int.parse(doc['horario'].toString().split(":")[1]));
            txtHorario.text = doc['horario'];
            if(data.isBefore(DateTime.now())) {
              podeCancelar = false;
            }
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
          title: Text( docId == null ? 'Agendar lavagem' : 'Editar lavagem' , style: const TextStyle(color: Colors.white)),
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
                                    dataSelecionada();
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
                                    horaSelecionada();
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    labelText: 'Horário',
                                    suffixIcon: Icon(Icons.access_time),
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
                                            if(valorPadraoDropDownCarro == 'Selecione') {
                                              dialogBox(context, 'Erro', 'Selecione o veículo');
                                            } else {
                                              Future<QuerySnapshot<Map<String, dynamic>>> future = CarroController().listarCarroNomeEspecifico(valorPadraoDropDownCarro);
                                              future.then((value) {
                                                dynamic doc = value.docs.first.data();
                                                marcaCarro = doc['marca'].toString();
                                                modeloCarro = doc['modelo'].toString();
                                                tipoCarro = doc['tipoCarro'].toString();
                                                Lavagem l = Lavagem(LoginController().idUsuarioLogado(), nomeCliente, cpfCliente, telefoneCliente, marcaCarro, modeloCarro, tipoCarro, data.toString(), txtHorario.text);
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
                              if(docId != null) if(podeCancelar == true) Center(child: ElevatedButton(
                                      style:  ButtonStyle(
                                        minimumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                                        shadowColor: WidgetStateProperty.all<Color>(Colors.green)
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

  Future<void> dataSelecionada() async {
    bool decidirSelecionarData(DateTime dia) {
    if(dia.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
    }

    DateTime? diaSelecionado = await showDatePicker(
    context: context, 
    firstDate: DateTime(DateTime.now().year), 
    lastDate: DateTime((DateTime.now().year) + 1),
    initialDate: data,
    confirmText: 'Salvar',
    cancelText: 'Cancelar',
    helpText: 'Selecione a data desejada',
    selectableDayPredicate: decidirSelecionarData,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.lightBlue,
            cardColor: Colors.white,
            primarySwatch: Colors.blue,
            accentColor: Colors.black
          )
        ), 
        child: child!);
    },
  );

  if(diaSelecionado != null && diaSelecionado != data) {
    setState(() {
      data = diaSelecionado;
      if(data.month < 10) {
        txtData.text = '${data.day}/0${data.month}/${data.year}';
      } else {
        txtData.text = '${data.day}/${data.month}/${data.year}';
      }
      
    });
  }
  }


  Future<void> horaSelecionada() async{
    TimeOfDay? hora = await showTimePicker(
      context: context, 
      initialTime: horarioSelecionado,

      confirmText: 'Salvar',
      cancelText: 'Cancelar',
      helpText: 'Selecione o horário desejado',
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch(
              backgroundColor: Colors.lightBlue,
              cardColor: Colors.white,
              primarySwatch: Colors.blue,
              accentColor: Colors.black,
            )
          ), 
          child: child!
        );
      },
    );

    if(hora != null && hora != horarioSelecionado) {
      setState(() {
        horarioSelecionado = hora;
        txtHorario.text = '${horarioSelecionado.hour}:${horarioSelecionado.minute}';
      });
    }
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
