import '../model/carroFipe.dart';
import 'package:dio/dio.dart'; // Utilizado para comunicação com API


class FipeService {
  final Dio dio = Dio();
  Future<CarroFipe?> listaInformacoesCarrosCliente(String codigoFipe, ano) async {
    var resposta = await dio.get(
      'https://fipe.parallelum.com.br/api/v2/cars/$codigoFipe/years/$ano-1'
    );

    if (resposta.statusCode == 200) {
      return CarroFipe.fromJson(resposta.data);
    } else {
      return null;
    }
  }
}