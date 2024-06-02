import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/carro_controller.dart';
import '../controller/lavagem_controller.dart';
import 'package:lava_car/view/editar_conta_view.dart';
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

  Color corConsultarCarro = Colors.black;
  Color corlistarCarrosCliente = Colors.black;

  @override
  Widget build(BuildContext context) {

    // Opções das páginas do BottomNavigationBar
  List<Widget> opcaoWidget = <Widget> [
    //menu Home -> mostra lavagens do dia do cliente e histórico de lavagens
    home(),
    // Menu Carros do cliente -> mostra todos os carros do cliente
    carrosCliente(),
    // Menu Consultar vaículo
    const Text('Consultando veículo')
  ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
      },
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
          backgroundColor: Colors.white,
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
                        color: Colors.grey.shade900
                      ),
                      title: const Text('Cadastrar carro'),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CadastrarCarro()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_calendar_outlined, color: Colors.grey.shade900),
                      selected: false,
                      title: const Text('Agendar lavagem'),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const AgendarLavagem())));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.grey.shade900),
                      title: const Text('Editar conta'),
                      selected: false,
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const EditarConta())));
                      },
                    ),
                    const Divider(color: Colors.black,),
                    ListTile(
                      leading:  Icon(Icons.help_outline_rounded, color: Colors.grey.shade900),
                      title: const Text('Sobre o aplicativo'),
                      selected: false,
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.pushNamed(context, 'sobre');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.grey.shade900),
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
          items:   [
             const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('lib/images/chave-do-carro.png',
                  width: 30,
                  height: 30,
                  color: corlistarCarrosCliente,
                ),
                label: 'Carros do cliente',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('lib/images/consulta-carro.png',
                  width: 30,
                  height: 30,
                  color: corConsultarCarro,
                ),
                label: 'Consultar carro',
              )
          ],
          backgroundColor: Colors.blue,
          currentIndex: itemSelecionado,
          selectedItemColor: Colors.white,
          onTap: (int indice) {
            if(indice == 1) {
              corlistarCarrosCliente = Colors.white;
            } else {
              corlistarCarrosCliente = Colors.black;
            }

            if(indice == 2) {
              corConsultarCarro = Colors.white;
            } else {
              corConsultarCarro = Colors.black;
            }
            setState(() {
              itemSelecionado = indice;
            });
          },
        ),
      ),
    );
  }

  // Carregamento das informações que aparecerão no Drawer
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
                      Navigator.of(context).push(MaterialPageRoute(builder:  ((context) => const EditarConta())));
                    },
                  ),
                  const Divider(color: Colors.black,),
                  ListTile(
                      leading:  Icon(Icons.help_outline_rounded, color: Colors.grey.shade900),
                      title: const Text('Sobre o aplicativo'),
                      selected: false,
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.pushNamed(context, 'sobre');
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
}


home() {
    return Center(
      child: Column(
          children: [
            Column(
                    children: [
                       const Center(
                        child: Text('Lavagem do dia', style: TextStyle( fontSize: 30, color: Colors.black))
                      ),
                      const SizedBox(height: 10),
                      //Mostra lavagem do dia do cliente
                      StreamBuilder<QuerySnapshot>(
                       stream: LavagemController().listarLavagemDoDia().snapshots(), 

                        builder: (context, snapshot) {
                          switch(snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Center(child: Text('Erro de conexão'));

                            case ConnectionState.waiting:
                              return  const CircularProgressIndicator(color: Colors.black);

                            default:
                              final dados = snapshot.requireData;

                              if(dados.size > 0) {
                                return ListView.builder(
                                  itemCount: dados.size,
                                  itemBuilder: (context, index) {
                                    dynamic doc = dados.docs[index].data();
                                    return const Card(
                                      child: ListTile(

                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Column(
                                  children: [
                                    Center(
                                      child: Text(
                                          'Não há lavagem', 
                                          style: TextStyle(
                                            fontSize: 20, 
                                            color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                    ),
                                    SizedBox(height: 20)
                                  ]
                                );
                              }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text('Lavagens anteriores', style: TextStyle( fontSize: 30, color: Colors.black))
                      ),
                      const SizedBox(height: 10),
                      //Mostra lavagens anteriores do cliente
                      StreamBuilder<QuerySnapshot>(
                       stream: LavagemController().listarLavagemDoDia().snapshots(), 

                        builder: (context, snapshot) {
                          switch(snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Center(child: Text('Erro de conexão'));

                            case ConnectionState.waiting:
                              return  const CircularProgressIndicator(color: Colors.black);

                            default:
                              final dados = snapshot.requireData;

                              if(dados.size > 0) {
                                return ListView.builder(
                                  itemCount: dados.size,
                                  itemBuilder: (context, index) {
                                    dynamic doc = dados.docs[index].data();
                                    return const Card(
                                      child: ListTile(

                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Column(
                                  children: [
                                    Center(
                                      child: Text(
                                          'Não há lavagem', 
                                          style: TextStyle(
                                            fontSize: 20, 
                                            color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                    ),
                                    SizedBox(height: 20)
                                  ]
                                );
                              }
                          }
                        },
                      ),
                    ]
                  )
          ],
        ),
      
    );
  }

carrosCliente() {
  return Center(
    child: Column(
      children: [
        const Text('Carros do cliente', style: TextStyle(fontSize: 30, color: Colors.black)),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: CarroController().listarCarrosCliente().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text('Erro de conexão'));
              case ConnectionState.waiting:
                return const CircularProgressIndicator(color: Colors.black);
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                      shrinkWrap: true, // Defina shrinkWrap como true
                      scrollDirection: Axis.vertical,
                      itemCount: dados.size,
                      itemBuilder: (context, index) {
                        String id = dados.docs[index].id;
                        dynamic doc = dados.docs[index].data();
                        return Card(
                          color: const Color.fromARGB(255, 0, 110, 255),
                          child: ListTile(
                            title: Text(doc['marca'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text('Modelo: ${doc['modelo']}\nAno: ${doc['ano']}\nMotorização: ${doc['motorização']}\nCor: ${doc['cor']}\nTipo: ${doc['tipoCarro']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'cadastrarCarro', arguments: id);
                                    }, 
                                    icon: const Icon(Icons.mode_edit_outlined, color: Colors.white,)
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      CarroController().removerCarro(context, id);
                                    }, 
                                    icon: const Icon(Icons.delete_outline_outlined, color: Colors.white,)
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                      },
                    );
                } else {
                  return const Center(
                    child: Text(
                      'Não há carro cadastrado',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
            }
          },
        )
      ],
    ),
  );
}