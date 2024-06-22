// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var visibilidadeSenha = Icon(Icons.visibility_off_outlined);
  bool naoVisivel = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
            'Tela de Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          backgroundColor: Colors.blue,
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
              decoration:  const BoxDecoration(
                color: Colors.blue, 
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
              ),
              child: Image.asset('lib/images/login.png')
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    TextFormField(
                      controller: txtEmail,
                      validator: (value) {
                        if(value == null) {
                          return 'Campo vazio';
                        } else if(value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: txtSenha,
                      obscureText: naoVisivel,
                      obscuringCharacter: '*',
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
                              if(naoVisivel == true) {
                                setState(() {
                                  visibilidadeSenha = Icon(Icons.visibility_outlined);
                                  naoVisivel = false;
                                });
                              } else {
                                setState(() {
                                  visibilidadeSenha = Icon(Icons.visibility_off_outlined);
                                  naoVisivel = true;
                                });
                              }
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text("Esqueceu a senha?"),
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                                      ),
                                      SizedBox(height: 25),
                                      TextField(
                                        controller: txtEmailEsqueceuSenha,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          prefixIcon: Icon(Icons.email),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actionsPadding: EdgeInsets.all(20),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancelar', style: TextStyle(color: Colors.white),),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      //
                                      // Enviar email recuperação de senha
                                      //
                                      LoginController().esqueceuSenha(
                                        context,
                                        txtEmailEsqueceuSenha.text,
                                      );
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green
                                    ),
                                    child: Text('Enviar', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Esqueceu a senha?'),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 40),
                        backgroundColor: Colors.blue
                      ),
                      onPressed: () {
                        //
                        // LOGIN
                        //
                        if(formKey.currentState!.validate()) {
                          LoginController().login(
                            context,
                            txtEmail.text,
                            txtSenha.text,
                          );
                          txtEmail.clear();
                          txtSenha.clear();
                        }
                      },
                      child: Text('Entrar', style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ainda não tem conta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'cadastrar');
                          },
                          child: Text('Cadastre-se'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],),
        ),
      ),
    );
  }
}