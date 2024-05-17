import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/usuario.dart';
import '../controller/login_controller.dart';
class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: 
        StreamBuilder<QuerySnapshot>(
              stream: LoginController().listarInformacoesClienteLogado().snapshot(), 
              
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text('Não Não foi possível conectar.')
                    );
                  
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    final dados = snapshot.requireData;
                    if(dados.size > 0) {
                      ListView.builder(
                        itemCount: dados.size,
                        itemBuilder: (context, index) {
                          String id = dados.docs[0].id;
                          dynamic doc = dados.docs[0].data();
                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              UserAccountsDrawerHeader(accountName: doc['nome'], accountEmail: doc['email'])
                            ],
                          );

                        },
                      );
                    } 
                }
                throw Exception(ex);
              }
            ),
      ),
    );
  }
  Exception ex(int codigoStatus) => throw Exception(const Dialog(child: Text('Erro')));
}