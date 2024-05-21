
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lava_car/controller/carro_controller.dart';
import 'package:lava_car/controller/lavagem_controller.dart';
import '../controller/login_controller.dart';

import 'cadastrar_carro_view.dart';
import 'agendar_lavagem_view.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  bool inicioSelecionado = true, agendarSelecionado = false, editarContaSelecionado = false, adicionarCarro = false;
  int itemSelecionado = 0;

  @override
  Widget build(BuildContext context) {

    // Opções das páginas do BottomNavigationBar
  List<Widget> opcaoWidget = <Widget> [
    //menu Home -> mostra lavagens do dia do cliente e histórico de lavagens
    Center(
      child: Column(
          children: [
            Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:   const BoxDecoration(
                    color: Colors.blue, 
                    borderRadius: BorderRadius.vertical( bottom: Radius.circular(50))
                  ),
                  child:  Column(
                    children: [
                       const Center(
                        child: Text('Lavagem do dia', style: TextStyle( fontSize: 30, color: Colors.white))
                      ),
                      StreamBuilder<QuerySnapshot>(
                       stream: LavagemController().listarLavagensCliente().snapshots(), 

                        builder: (context, snapshot) {
                          switch(snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Center(child: Text('Erro de conexão'));

                            case ConnectionState.waiting:
                              return  const CircularProgressIndicator(color: Colors.white);

                            default:
                              final dados = snapshot.requireData;

                              if(dados.size > 0) {
                                return ListView.builder(
                                  itemCount: dados.size,
                                  itemBuilder: (context, index) {
                                    
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    'Não há lavagem', 
                                    style: TextStyle(
                                      fontSize: 30, 
                                      color: Colors.white
                                      )
                                    )
                                  );
                              }
                          }
                        },
                      ),
                      // StreamBuilder<QuerySnapshot>(),
                    ]
                  )
            )
            

          ],
        ),
      
    ),
    const Text('Página 2'),
    const Text('Consultando veículo')
  ];
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  return carregando();
      
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
                        backgroundColor: Colors.white,
                        child: Text(doc['nome'][0], 
                        style: const TextStyle(fontSize: 30, color: Colors.blue)),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      selected: true,
                      selectedColor: Colors.blue,
                      title: const Text('Início'),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                    ListTile(
                      selected: false,
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
                      selected: false,
                      title: const Text('Agendar lavagem'),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const AgendarLavagem())));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Editar conta'),
                      selected: false,
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
        
        body:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5), 
              opcaoWidget.elementAt(itemSelecionado)
              ]
            ),
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
      ),
    );
  }


  carregando() {
    return ListView(
                padding: EdgeInsets.zero,
                children: [
                  const UserAccountsDrawerHeader(
                    decoration:  BoxDecoration(color: Colors.blue),
                    accountEmail:  SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: Colors.white)),
                    accountName:  SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: Colors.white)),
                    currentAccountPicture:  CircleAvatar(
                      child: CircularProgressIndicator(color: Colors.blue)
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    selected: true,
                    title: const Text('Início'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    selected: false,
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
                    selected: false,
                    title: const Text('Agendar lavagem'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const AgendarLavagem())));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Editar conta'),
                    selected: false,
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
}