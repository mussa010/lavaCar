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
              stream: LoginController().listarInformacoesClienteLogado(), 
              
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
                          String id;
                        },
                      );
                    }
                }
              }
            ),
            UserAccountsDrawerHeader(accountName: Text(usuario.getNome()), accountEmail: Text(usuario.getEmail())),
            const ListTile(
              leading: Icon(Icons.directions_car, color: Colors.white,),
              title: Text('Cadastrar carro', style: TextStyle(color: Colors.white)),
            ),
      ),
    );
  }
}