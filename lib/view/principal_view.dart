import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/login_controller.dart';
class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  @override
  bool inicioSelecionado = true, agendarSelecionado = false, minhaContaSelecionado = false;
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
                    selected: true,
                    title: const Text('Incício'),
                    onTap: () {
                      Navigator.pop(context);
                      
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_calendar_outlined),
                    title: const Text('Agendar lavagem'),
                    onTap: () {
                      Navigator.pop(context);
                      //Navegar para outra página
                    },
                  ),
                  ListTile(
                    leading: Image.asset('lib/images/carro-esportivo.png', 
                    width: 30,
                    height: 30,
                      color: Colors.black,
                    ),
                    title: const Text('Adicionar carro'),
                    onTap: () {
                      Navigator.pop(context);
                      //Navegar para outra página
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Editar conta'),
                    onTap: () {
                      Navigator.pop(context);
                      //Navegar para outra página
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
      body: Scaffold(
        
      ),
    );
  }
}