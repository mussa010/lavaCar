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
  void initState() {
    super.initState();
    txtEmail.text = 'math_200901@hotmail.com';
    txtSenha.text = '1234567890';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 60),
              ),
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
                    border: OutlineInputBorder()),
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
                    border: OutlineInputBorder()),
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
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actionsPadding: EdgeInsets.all(20),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('cancelar'),
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
                              child: Text('enviar'),
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
                child: Text('Entrar'),
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
        )
      ),
    );
  }
}