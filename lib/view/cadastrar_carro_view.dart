import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/login_controller.dart';
import 'package:lava_car/model/veiculo.dart';
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
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)!.settings.arguments;
    

    if (docId != null) {
      // Carrega os dados do carro selecionado
      carregarDadosCarro(docId);
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'principal');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(docId == null ? 'Cadastrar carro' : 'Editar carro', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                      if (value == null || value.isEmpty) {
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
                      if (value == null || value.isEmpty) {
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
                      if (value == null || value.isEmpty) {
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
                      if (value == null || value.isEmpty) {
                        return 'Campo vazio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.red)
                        ),
                        child: const Center(
                          child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'principal');
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.green)
                        ),
                        child: const Center(
                          child: Text('Salvar', style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if(txtAno.text.length == 4) {
                              Carro c = Carro(txtModeloCarro.text, txtMarca.text, int.parse(txtAno.text), txtCor.text, LoginController().idUsuarioLogado());
                              if (docId == null) {
                                CarroController().adicionarCarroDeCliente(context, c);
                              } else {
                                CarroController().editarCarroCliente(context, c, docId);
                              }
                            } else {
                              dialogBox(context, 'Erro', 'Tamanho do ano incorreto!');
                            }
                          }
                        },
                      ),
                    ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Carrega dados de carro selecionado na tela principal
  Future<void> carregarDadosCarro(docId) async {
    final DocumentSnapshot<Object?> snapshot = await CarroController().listaCarroEspecifico(docId);
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final Carro c = Carro.fromJson(data);
        txtMarca.text = c.getMarca();
        txtModeloCarro.text = c.getModelo();
        txtAno.text = c.getAno();
        txtCor.text = c.getCor();
    }
  }

  dialogBox(BuildContext context, String titulo, String mensagem) {
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
}
