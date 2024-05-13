// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  var maskCpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')}
  );

  var maskData = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')}
  );

  var maskTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')}
  );

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
              controller: txtDataNascimento,
              inputFormatters: [maskData],
              decoration: InputDecoration(
                  labelText: 'Data de nascimento',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtCpf,
              inputFormatters: [maskCpf],
              decoration: InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            Row(children: [
              Text('Gênero:'), 
              SizedBox(width: 15),
              DropdownButton(
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
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtTelefone,
              inputFormatters: [maskTelefone],
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
                      print('deu certo');
                    } else {
                      LoginController().criarConta(
                        context, 
                        txtNome.text, 
                        txtEmail.text, 
                        txtSenha.text, 
                        txtDataNascimento.text, 
                        txtCpf.text, 
                        valorPadraoDropDown, 
                        txtTelefone
                      );
                      print('deu certo');
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