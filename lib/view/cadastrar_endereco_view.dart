import 'package:flutter/material.dart';
import 'package:lava_car/controller/endereco_controller.dart';
import 'package:lava_car/model/endereco.dart';
import 'package:mask/mask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/login_controller.dart';
import '../service/endereco_service.dart';

class CadastrarEndereco extends StatefulWidget {
  const CadastrarEndereco({super.key});

  @override
  State<CadastrarEndereco> createState() => _CadastrarEndereco();
}

class _CadastrarEndereco extends State<CadastrarEndereco> {
  var txtEndereco = TextEditingController();
  var txtNumero = TextEditingController();
  var txtBairro = TextEditingController();
  var txtComplemento = TextEditingController(); 
  var txtCidade = TextEditingController();
  var txtEstado = TextEditingController();
  var txtCep = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool cadastrado = false;
  String titulo = '';

  @override
  void initState() {
    super.initState();

    Future<QuerySnapshot<Map<String, dynamic>>> future = EnderecoController().listarEndereco();

    future.then(
      (value) {
        if(value.size == 0) {
          setState(() {
            cadastrado = false;
            titulo = 'Cadastrar endereço';
          });
        } else {
          dynamic doc = value.docs[0].data();

          setState(() {
            txtEndereco.text = doc['endereco'].toString();
            txtNumero.text = doc['numero'].toString();
            txtBairro.text = doc['bairro'].toString();
            txtComplemento.text = doc['complemento'].toString();
            txtCidade.text = doc['cidade'].toString();
            txtEstado.text = doc['estado'].toString();
            txtCep.text = doc['cep'].toString();
            cadastrado = true;
            titulo = 'Editar endereço';
          });
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(titulo, style: const TextStyle(color: Colors.white)),
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
                      controller: txtCep,
                      keyboardType: TextInputType.number,
                      inputFormatters: [Mask.generic(masks: ['#####-###'])],
                      decoration: const InputDecoration(
                        labelText: 'CEP',
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
                      onChanged: (value) {
                        if(value.length == 9) {
                          String cepNotFormatted = '';

                          for(int i = 0; i < value.length; i++) {
                            if(value[i] != '-') {
                              cepNotFormatted += value[i];
                            }
                          }

                          Future<Endereco?> end = EnderecoService().listarInformacoesEnderecoPorCep(cepNotFormatted);
                          end.then((value) {
                            if(value != null) {
                              setState(() {
                                txtEndereco.text = value.getEndereco();
                                txtBairro.text = value.getBairro();
                                txtCidade.text = value.getCidade();
                                txtEstado.text = value.getEstado();
                              });
                            } else {
                              // Verificar aqui, não abre mensagem de erro
                              // dialogBox(context, 'Erro', 'CEP não encontrado!');
                            }
                          },);


                        } else {
                          setState(() {
                                txtEndereco.text = '';
                                txtBairro.text = '';
                                txtCidade.text = '';
                                txtEstado.text = '';
                              });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  TextFormField(
                      controller: txtEndereco,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
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
                      controller: txtNumero,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número',
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
                      controller: txtBairro,
                      enabled: false,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
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
                      controller: txtComplemento,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Complemento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20)
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtCidade,
                      enabled: false,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
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
                      controller: txtEstado,
                      enabled: false,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
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
                            Endereco e = Endereco(txtEndereco.text, txtNumero.text, txtBairro.text, txtComplemento.text, txtCep.text, txtCidade.text, txtEstado.text, LoginController().idUsuarioLogado());
                              if(cadastrado == false) {
                                EnderecoController().cadastroEndereco(context, e);
                              } else {
                                EnderecoController().editarEndereco(context, e);
                              }
                          }
                        },
                      ),
                    ]
                ),
                const SizedBox(height: 20),
                if(cadastrado == true)ElevatedButton(
                  style:  ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                    shadowColor: WidgetStateProperty.all<Color>(Colors.red)
                  ),
                  child: const Center(
                    child: Text('Apagar endereço',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  
                  onPressed: () {
                    EnderecoController().apagarEndereco(context);
                    Navigator.pushReplacementNamed(context, 'principal');
                  },
                ),
                ],
              ),
            ),
          ),
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