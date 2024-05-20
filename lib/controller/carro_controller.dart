import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lava_car/view/util.dart';

import '../model/veiculo.dart';



class CarroController {
  //adicionar veículo de cliente específico
  adicionarCarroDeCliente (context, Veiculo v){
    return FirebaseFirestore.instance.collection('veiculo cliente').add(
      v.toJson()
    ).
    then((resultado) {
      sucesso(context, 'Veículo cadastrado com sucesso');
    });
  }

}