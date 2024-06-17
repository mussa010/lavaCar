import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  String nomeCliente = '', cpfCliente = '', telefoneCliente = '',  marcaCarro = '', modeloCarro = '', tipoCarro = '', placaCarro = '',  valorPadraoDropDownCarro = 'Selecione', uidLavagem = '';
  var uidCliente = LoginController().idUsuarioLogado();
  bool podeCancelar = true, podeSalvar = true;
  DateTime? data;
  TimeOfDay horarioSelecionado = TimeOfDay.now();



  @override
  void initState() {
    super.initState();
    String day,month;

    if(DateTime.now().month < 10) {
      month = '0${DateTime.now().month}';
    } else {
      month = '${DateTime.now().month}';
    }

    if(DateTime.now().day < 10) {
      day = '0${DateTime.now().day}';
    } else {
      day = '${DateTime.now().day}';
    }

    data = DateTime.parse('${DateTime.now().year}-$month-$day');

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
            placaCarro = doc['placaCarro'].toString();
            tipoCarro = doc['tipoCarro'].toString();
            uidLavagem = doc['uidLavagem'].toString();
            data = DateTime.parse(doc['data'.toString()]);
            if(data!.month < 10) {
              txtData.text = '${data!.day}/0${data!.month}/${data!.year}';
            } else {
              txtData.text = '${data!.day}/${data!.month}/${data!.year}';
            }

            horarioSelecionado = TimeOfDay(hour: int.parse(doc['horario'].toString().split(":")[0]), minute: int.parse(doc['horario'].toString().split(":")[1]));
            txtHorario.text = doc['horario'];
            if(data!.isBefore(DateTime.now())) {
              podeCancelar = false;
              podeSalvar = false;
            }
          });
        });
      } 
    });
  }


  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)!.settings.arguments;
    bool podeEditar = true, podeIgnorar = false;

    if(podeSalvar == false) {
      podeEditar = false;
      podeIgnorar = true;
    }

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
                FutureBuilder<QuerySnapshot>(
                  future: CarroController().listarCarrosCliente().get(), 
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
                                  enabled: podeEditar,
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
                                    dataSelecionada(context);
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
                                  enabled: podeEditar,
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    horaSelecionada(context);
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
                                    IgnorePointer(
                                      ignoring: podeIgnorar,
                                      child: DropdownButton(
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
                                        },
                                      ),
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
                                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                                        shadowColor: WidgetStateProperty.all<Color>(Colors.blue)
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
                                    if(podeSalvar == true) ElevatedButton(
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
                                                placaCarro = doc['placa'].toString();
                                                Lavagem l = Lavagem(LoginController().idUsuarioLogado(), nomeCliente, cpfCliente, telefoneCliente, marcaCarro, modeloCarro, modeloCarro.toUpperCase(), tipoCarro, placaCarro, data.toString(), txtHorario.text);
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

  Future<void> dataSelecionada(context) async {
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
      String? dia, mes;
      data = diaSelecionado;
      if(diaSelecionado.day < 10) {
        dia = '0${diaSelecionado.day}';
      } else {
        dia = '${diaSelecionado.day}';
      }

      if(diaSelecionado.month < 10) {
        mes = '0${diaSelecionado.month}';
      } else {
        mes = '${diaSelecionado.month}';
      }

      txtData.text = '$dia/$mes/${data!.year}';
      
      });
  } else {
    dialogBox(context, 'Erro', 'Não é possível selecionar essa data!');
  }
  }


  Future<void> horaSelecionada(context) async{
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
        String? m, h;
        horarioSelecionado = hora;
        if(horarioSelecionado.minute < 10) {
          m = '0${horarioSelecionado.minute}';
        } else {
          m = '${horarioSelecionado.minute}';
        }
        
        if(horarioSelecionado.hour< 10) {
          h = '0${horarioSelecionado.hour}';
        } else {
          h = '${horarioSelecionado.hour}';
        }
        txtHorario.text = '$h:$m';
      });
    } else {
      dialogBox(context, 'Erro', 'Não é possível selecionar esse horário!');
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
            onPressed: () => Navigator.pop(context, 'Ok'),
            child: const Text('Ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
