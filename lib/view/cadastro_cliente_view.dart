// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/usuario_controller.dart';

import '../controller/login_controller.dart';
import 'package:mask/mask.dart';

import '../model/usuario.dart';

class CadastrarCliente extends StatefulWidget {
  const CadastrarCliente({super.key});

  @override
  State<CadastrarCliente> createState() => _CadastrarCliente();
}

bool senhaNaoVisivel = true, confirmarSenhaNaoVisivel = true;

class _CadastrarCliente extends State<CadastrarCliente> {
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtConfirmarSenha = TextEditingController();
  var txtDataNascimento = TextEditingController();
  var txtCpf = TextEditingController();
  var txtGenero = TextEditingController();
  var txtTelefone = TextEditingController();
  var txtOutroGenero = TextEditingController();
  var txtConfirmarEmail = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var visibilidadeSenha = Icon(Icons.visibility_off_outlined), visibilidadeConfirmarSenha = Icon(Icons.visibility_off_outlined);

  var generos = [
    'Masculino',
    'Feminino',
    'Não-binário',
    'Agênero',
    'Gênero fluido',
    'Transexual',
    'Outro',
    'Selecione'
  ];

  String valorPadraoDropDown = 'Selecione';

  bool ativado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      final docId = ModalRoute.of(context)!.settings.arguments;

      if(docId != null) {
        Future<QuerySnapshot<Map<String, dynamic>>> future = UsuarioController().listarInformacoesClienteLogado().snapshots().first;

        future.then((value) {
          dynamic doc = value.docs.first.data();
          setState(() {
            txtNome.text = doc['nome'].toString();
            txtDataNascimento.text = doc['dataNascimento'].toString();
            txtCpf.text = doc['cpf'].toString();
            if(doc['genero'].toString() == 'Outro') {
              valorPadraoDropDown = 'Outro';
              txtGenero.text = doc['genero'].toString();
            } else {
              valorPadraoDropDown = doc['genero'].toString();
            }
            txtTelefone.text = doc['telefone'].toString();
            txtEmail.text = doc['email'].toString();
            txtConfirmarEmail.text = doc['email'].toString();
          });
        });
      }
    });
  }

  String mensagem = 'A senha possui o(s) seguinte(s) erro(s):\n';

  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context)!.settings.arguments;
    // Cadastro de cliente
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(docId == null) {
            Navigator.pushReplacementNamed(context, 'login');
          } else {
            Navigator.pushReplacementNamed(context, 'principal');
          }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if(docId == null) {
                Navigator.pushReplacementNamed(context, 'login');
              } else {
                Navigator.pushReplacementNamed(context, 'principal');
              }
            },
          ),
          centerTitle: true,
          title:  Text(
            docId == null ? 'Criar Conta' : 'Editar conta',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
                Padding(padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: txtNome,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          Mask.date()
                        ],
                        controller: txtDataNascimento,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Data de nascimento',
                            prefixIcon: Icon(Icons.date_range),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: txtCpf,
                        inputFormatters: [Mask.cpfOrCnpj()],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'CPF/CNPJ',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Text('Gênero:'), 
                        SizedBox(width: 15),
                        DropdownButton(
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          value: valorPadraoDropDown,
                          items: generos.map((String generos) {
                            return DropdownMenuItem( 
                                value: generos, 
                                child: Text(generos),

                              ); 
                          }).toList(), 
                          onChanged: (String? novoValor) {
                          setState(() {
                            valorPadraoDropDown = novoValor!;
                            if(generos.contains('Selecione') && valorPadraoDropDown != 'Selecione') {
                                    generos.remove('Selecione');
                            }
                            
                            if(valorPadraoDropDown == 'Outro') {
                              ativado = true;
                            } else {
                              setState(() {
                                txtGenero.clear();
                                ativado = false;
                              });
                            }
                          });
                      }),]),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: txtOutroGenero,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            labelText: 'Gênero',
                            prefixIcon: Icon(const IconData(0xed6f, fontFamily: 'MaterialIcons')),
                            enabled: ativado,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        validator: (value) {
                          if(valorPadraoDropDown == 'Outro') {
                            if(value == null) {
                              return 'Campo vazio';
                            } else if(value.isEmpty) {
                              return 'Campo vazio';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: txtTelefone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [Mask.generic(masks: ['+## (##) ####-####', '+## (##) #####-####'])],
                        decoration: InputDecoration(
                            labelText: 'Telefone',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))
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
                      if(docId == null)  SizedBox(height: 15),
                      if(docId == null)  TextFormField(
                        controller: txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      ),
                      if(docId == null)  SizedBox(height: 15),
                      if(docId == null)  TextFormField(
                        controller: txtConfirmarEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Confirmar e-mail',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                      ),
                      if(docId == null)  SizedBox(height: 15),
                      if(docId == null)  TextFormField(
                        controller: txtSenha,
                        obscureText: senhaNaoVisivel,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              style: ButtonStyle(iconColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                if(states.contains(WidgetState.pressed)) {
                                  return Colors.blue;
                                } else {
                                  return null;
                                } 
                              })),
                              icon: visibilidadeSenha,
                              onPressed: () {
                                if(senhaNaoVisivel == true) {
                                  setState(() {
                                    visibilidadeSenha = Icon(Icons.visibility_outlined);
                                    senhaNaoVisivel = false;
                                  });
                                } else {
                                  setState(() {
                                    visibilidadeSenha = Icon(Icons.visibility_off_outlined);
                                    senhaNaoVisivel = true;
                                  });
                                }
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))
                        ),
                      ),
                      if(docId == null)  SizedBox(height: 15),
                      if(docId == null)  TextFormField(
                        controller: txtConfirmarSenha,
                        obscureText: confirmarSenhaNaoVisivel,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value == null) {
                            return 'Campo vazio';
                          } else if(value.isEmpty) {
                            return 'Campo vazio';
                          } 
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Confirmar senha',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              style: ButtonStyle(iconColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                if(states.contains(WidgetState.pressed)) {
                                  return Colors.blue;
                                } else {
                                  return null;
                                } 
                              })),
                              icon: visibilidadeConfirmarSenha,
                              onPressed: () {
                                if(confirmarSenhaNaoVisivel == true) {
                                  setState(() {
                                    visibilidadeConfirmarSenha = Icon(Icons.visibility_outlined);
                                    confirmarSenhaNaoVisivel = false;
                                  });
                                } else {
                                  setState(() {
                                    visibilidadeConfirmarSenha = Icon(Icons.visibility_off_outlined);
                                    confirmarSenhaNaoVisivel = true;
                                  });
                                }
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              if(docId == null) {
                                Navigator.pushReplacementNamed(context, 'login');
                              } else {
                                Navigator.pushReplacementNamed(context, 'principal');
                              }
                            },
                            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 15,),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(140, 40),
                            ),
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                if(docId == null) {
                                  if(valorPadraoDropDown != 'Selecione') {
                                    if(txtSenha.text == txtConfirmarSenha.text && txtEmail.text == txtConfirmarEmail.text) {
                                      if(aSenhaEValida(txtSenha.text) == true) {
                                        if(valorPadraoDropDown == 'Outro') {
                                          LoginController().criarConta(
                                            context,
                                            txtNome.text,
                                            txtEmail.text,
                                            txtSenha.text,
                                            txtDataNascimento.text,
                                            txtCpf.text,
                                            txtGenero.text,
                                            txtTelefone.text
                                          );
                                        } else {
                                          LoginController().criarConta(
                                            context, 
                                            txtNome.text, 
                                            txtEmail.text, 
                                            txtSenha.text, 
                                            txtDataNascimento.text, 
                                            txtCpf.text, 
                                            valorPadraoDropDown, 
                                            txtTelefone.text
                                          );
                                        }
                                      } else {
                                        dialogBox(context, 'Erro', mensagem);
                                        mensagem = 'A senha possui o(s) seguinte(s) erro(s):\n';
                                      }
                                    } else {
                                      dialogBox(context, 'Erro', 'As senhas ou e-mails não estão iguais');
                                      txtSenha.clear();
                                      txtConfirmarSenha.clear();
                                    }
                                  } else {
                                    dialogBox(context, 'Erro', 'Selecione seu gênero!');
                                  }
                                  
                                } else {
                                  if(valorPadraoDropDown != 'Selecione') {
                                    Usuario u;
                                    if(valorPadraoDropDown == 'Outro') {
                                      u = Usuario(txtNome.text, txtDataNascimento.text, txtCpf.text, txtGenero.text, txtTelefone.text);
                                    } else {
                                      u = Usuario(txtNome.text, txtDataNascimento.text, txtCpf.text, valorPadraoDropDown, txtTelefone.text);
                                    }
                                    UsuarioController().editarInformacoesCliente(context, u, docId);
                                  } else {
                                    dialogBox(context, 'Erro', 'Selecione seu gênero!');
                                  }
                                }
                              }
                            },
                            child: Text(docId == null ? 'Criar' : 'Salvar', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                  
                )
            ],
          ) 
        )
      )
    );
  }

  bool aSenhaEValida(String senha) {
    bool temMaiusculo = false, temMinusculo = false, temEspecial = false, maiorIgualTamMin = false;
    int tamMinimo = 8;

    if(senha.length >= tamMinimo) {
      maiorIgualTamMin = true;
    } else {
      mensagem += 'Tamanho da senha é menor que 8\n';
    }

    if(senha.contains(RegExp(r'[A-Z]'))) {
      temMaiusculo = true;
    } else {
      mensagem += 'Senha não possui caractere maiúsculo\n';
    }

    if(senha.contains(RegExp(r'[a-z]'))) {
      temMinusculo = true;
    } else {
      mensagem += 'Senha não possui caractere minúsculo\n';
    }

    if(senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      temEspecial = true;
    } else {
      mensagem += 'Senha não possui caractere especial\n';
    }

    if(maiorIgualTamMin == true && temMaiusculo == true && temMinusculo == true && temEspecial == true) {
      return true;
    } else {
      return false;
    }
  }
}



dialogBox(context, titulo, mensagem) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: Text(titulo),
        content: Text(mensagem),

        actions: [
          TextButton(onPressed: () => Navigator.pop(context, 'Voltar'),
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Voltar', style: TextStyle(color: Colors.white)),  
        )
        ],
      ));
  }


  