import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CadastrarCarro extends StatefulWidget {
  const CadastrarCarro({super.key});

  @override
  State<CadastrarCarro> createState() => _CadastrarCarro();
}

class _CadastrarCarro extends State<CadastrarCarro> {
  var txtAno = TextEditingController();
  var txtModeloCarro = TextEditingController();
  var txtMarca = TextEditingController();
  var txtCor = TextEditingController();

  var tipos = [
    'Hatchback',
    'Sedan',
    'SUV',
    'Crossover',
    'Coupe',
    'Conversível',
    'Minivan',
    'Caminhonete',
    'Perua',
    'Carro Esportivo',
    'Carro de Luxo'
  ];
  

  var motorizacao = [
    '1.0',
    '1.4',
    '1.6',
    '1.8',
    '2.0'
  ];

    String valorPadraoDropDownMotorizacao = '', valorPadraoDropDownTipos = '';

  @override
  void initState() {
    super.initState();
    tipos.sort();
    motorizacao.sort();
    valorPadraoDropDownMotorizacao = motorizacao.first;
    valorPadraoDropDownTipos = tipos.first;
  }


  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'principal');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar carro', style: TextStyle(color: Colors.white)),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
            children: [
              TextField(
                controller: txtMarca,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )
                  )
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: txtModeloCarro,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )
                  )
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: txtAno,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )
                  )
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: txtCor,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Cor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    )
                  )
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Motorização:'),
                  const SizedBox(width: 15),
                  DropdownButton(
                    value: valorPadraoDropDownMotorizacao,
                    items: motorizacao.map((String motorizacao) {
                      return DropdownMenuItem(
                        value: motorizacao,
                        child: Text(motorizacao),
                      );
                    }).toList(), 
                    onChanged: (String? novoValor) {
                      setState(() {
                        valorPadraoDropDownMotorizacao = novoValor!;
                      });
                    }
                  )
                ]
              ), 
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Tipo:'),
                  const SizedBox(width: 15),
                  DropdownButton(
                    value: valorPadraoDropDownTipos,
                    items: tipos.map((String tipos) {
                      return DropdownMenuItem(
                        value: tipos,
                        child: Text(tipos),
                      );
                    }).toList(), 
                    onChanged: (String? novoValor) {
                      setState(() {
                        valorPadraoDropDownTipos = novoValor!;
                      });
                    }
                  )
                ]
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style:  ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.green)
                    ),
                    child: const Center(
                      child: Text('Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    
                    onPressed: () {
                      // Parou aqui
                    },
                  ),
                  ElevatedButton(
                    style:  ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.05)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.red)
                    ),
                    child: const Center(
                      child: Text('Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'principal');
                    },
                  ),
                ]
            )
            ],
          ),
          )
        )
      )
    );
  }
}