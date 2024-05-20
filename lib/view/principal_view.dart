
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

import 'cadastrar_carro_view.dart';
import 'agendar_lavagem_view.dart';
import '../model/usuario.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  bool inicioSelecionado = true, agendarSelecionado = false, editarContaSelecionado = false, adicionarCarro = false;
  int itemSelecionado = 0;

  // Opções das páginas do BottomNavigationBar
  static const List<Widget> opcaoWidget = <Widget> [
    Text('Home'),
    Text('Página 2'),
    Text('Consultando veículo')
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Início',
          style: TextStyle(color: Colors.white),
        ),
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
                    currentAccountPicture: CircleAvatar(
                      child: Text(doc['nome'][0], 
                      style: const TextStyle(fontSize: 30))
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    selected: inicioSelecionado,
                    title: const Text('Início'),
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
                    selected: adicionarCarro,
                    leading: Image.asset('lib/images/carro-esportivo.png', 
                    width: 30,
                    height: 30,
                      color: Colors.black,
                    ),
                    title: const Text('Cadastrar carro'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CadastrarCarro()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_calendar_outlined),
                    selected: agendarSelecionado,
                    title: const Text('Agendar lavagem'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const AgendarLavagem())));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Editar conta'),
                    selected: editarContaSelecionado,
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  const Divider(color: Colors.black,),
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
      
      body:  Padding(
        padding: const EdgeInsets.all(20),
        child: opcaoWidget.elementAt(itemSelecionado),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
             label: 'Home',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm_rounded),
             label: 'Tela 2',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
             label: 'Consultar carro',
            )
        ],
        backgroundColor: Colors.blue,
        currentIndex: itemSelecionado,
        selectedItemColor: Colors.white,
        onTap: (int indice) {
          setState(() {
            itemSelecionado = indice;
          });
        },
      ),
    );
  }


  // lavagensCliente() {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         children: [

  //         ],
  //       ),
  //     )
  //   );
  // }
}