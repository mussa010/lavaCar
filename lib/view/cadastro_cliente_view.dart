// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import 'package:mask/mask.dart';

class CadastrarView extends StatefulWidget {
  const CadastrarView({super.key});

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtConfirmarSenha = TextEditingController();
  var txtDataNascimento = TextEditingController();
  var txtCpf = TextEditingController();
  var txtGenero = TextEditingController();
  var txtTelefone = TextEditingController();
  var txtOutroGenero = TextEditingController();

  var generos = [
    'Masculino',
    'Feminino',
    'Não-binário',
    'Agênero',
    'Gênero fluido',
    'Transexual',
    'Outro'
  ];

  String valorPadraoDropDown = 'Masculino';

  bool ativado = false;

  dialogBox(context, titulo, mensagem) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, 'Voltar'),
          child: const Text('Voltar'))
        ],
      ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
        child: Column(
          children: [
            Text(
              'Criar Conta',
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 60),
            TextField(
              controller: txtNome,
              decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                Mask.date()
              ],
              controller: txtDataNascimento,
              decoration: InputDecoration(
                  labelText: 'Data de nascimento',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtCpf,
              inputFormatters: [Mask.cpfOrCnpj()],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'CPF/CNPJ',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
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
            TextField(
              controller: txtOutroGenero,
              decoration: InputDecoration(
                  labelText: 'Gênero',
                  prefixIcon: Icon(IconData(0xed6f, fontFamily: 'MaterialIcons')),
                  enabled: ativado,
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtTelefone,
              inputFormatters: [Mask.generic(masks: ['(##) ####-####', '(##) #####-####'])],
              decoration: InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtEmail,
              decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtSenha,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtConfirmarSenha,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancelar'),
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(140, 40),
                  ),
                  onPressed: () {
                    if(txtSenha.text == txtConfirmarSenha.text) {
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
                      dialogBox(context, 'Erro', 'As senhas não são iguais');
                      txtSenha.clear();
                      txtConfirmarSenha.clear();
                    }
                  },
                  child: Text('salvar'),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),)
    );
  }
}