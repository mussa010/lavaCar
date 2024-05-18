import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../controller/login_controller.dart';
class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  bool inicioSelecionado = true, agendarSelecionado = false, editarContaSelecionado = false, adicionarCarro = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }, 
                icon: const Icon(Icons.menu, color: Colors.white,)
              );
            }
          ),
      ),
      drawer: Drawer(
        child: 
        StreamBuilder<QuerySnapshot> (
        stream: LoginController().listarInformacoesClienteLogado().snapshots(),

        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                  child: Text('Não foi possível conectar.'),
              );

              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
              final dados = snapshot.requireData;
              dynamic doc = dados.docs[0].data();
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    accountEmail: Text(doc['email']),
                    accountName: Text(doc['nome']),
                    currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    selected: inicioSelecionado,
                    title: const Text('Incício'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      setState(() {
                        inicioSelecionado = true;
                        agendarSelecionado = false;
                        editarContaSelecionado = false;
                        adicionarCarro = false;
                     });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_calendar_outlined),
                    selected: agendarSelecionado,
                    title: const Text('Agendar lavagem'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      setState(() {
                        inicioSelecionado = false;
                        agendarSelecionado = true;
                        editarContaSelecionado = false;
                        adicionarCarro = false;
                      });
                    },
                  ),
                  ListTile(
                    selected: adicionarCarro,
                    leading: Image.asset('lib/images/carro-esportivo.png', 
                    width: 30,
                    height: 30,
                      color: Colors.black,
                    ),
                    title: const Text('Adicionar carro'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      setState(() {
                        inicioSelecionado = false;
                        agendarSelecionado = false;
                        editarContaSelecionado = false;
                        adicionarCarro = true;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Editar conta'),
                    selected: editarContaSelecionado,
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      setState(() {
                        inicioSelecionado = false;
                        agendarSelecionado = false;
                        editarContaSelecionado = true;
                        adicionarCarro = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Sair'),
                    onTap: () {
                      LoginController().logout();
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                  )
                ],
              );
          }
          
        },
      )
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Desenvolvendo', textAlign: TextAlign.center),
      )
    );
  }
}