import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/carro_controller.dart';

class AgendarLavagem extends StatefulWidget {
  const AgendarLavagem({super.key});

  @override
  State<AgendarLavagem> createState() => _AgendarLavagem();
}

class _AgendarLavagem extends State<AgendarLavagem> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'principal');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agendar lavagem', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded) ,
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'principal');
            },
            color: Colors.white,
          ), 
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: CarroController().listarCarrosCliente().snapshots(), 
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(child: Text('Erro de conexão'));

                    case ConnectionState.waiting:
                      return  const CircularProgressIndicator(color: Colors.black);

                    default:
                      final dados = snapshot.requireData;

                      if(dados.size == 0) {
                        return const Center(
                          child: Text(
                            'Você não possui carro cadastrado!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: dados.size,
                          itemBuilder: (context, index) {
                            dynamic doc = dados.docs[index].data();


                          },
                          
                        );
                      }
                  }
                },
              ),
            ],
          )

        ),
      )
    );
  }
}