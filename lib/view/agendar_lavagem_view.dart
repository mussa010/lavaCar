import 'package:flutter/material.dart';

class AgendarLavagem extends StatefulWidget {
  const AgendarLavagem({super.key});

  @override
  State<AgendarLavagem> createState() => _AgendarLavagem();
}

class _AgendarLavagem extends State<AgendarLavagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}