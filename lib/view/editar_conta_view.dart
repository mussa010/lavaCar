import 'package:flutter/material.dart';

class EditarConta extends StatefulWidget {
  const EditarConta({super.key});

  @override
  State<EditarConta> createState() => _EditarConta();
}

class _EditarConta extends State<EditarConta> {
  @override
  Widget build(BuildContext context) {
    return PopScope ( 
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(context, 'principal');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar conta', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded) ,
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'principal');
            },
            color: Colors.white,
          ), 
        ),
    )
    );
  }
}