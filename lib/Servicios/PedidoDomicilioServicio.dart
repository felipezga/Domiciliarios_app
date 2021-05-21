import 'dart:convert';

import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:http/http.dart';

class PedidoDomiclioRepository {
  Future<List<Pedido>> fetchPedidoUser(String userName) async {
    //String api = 'https://api.github.com/users/${userName}';
    String api = 'http://bengkelrobot.net:8001/${userName}';
    print(api);
    print("appaa");
    return await get(api).then((data) {
      print(data);
      print("dataaa");


      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        print(jsonData);
        print(jsonData[0]);
        // If the call to the server was successful, parse the JSON

        List<Pedido> pedidos = PedidosFromJson(jsonData);
        return pedidos;
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }


      /*if (jsonData['message'] == "Not Found") {
        throw UserNotFoundException();
      } else {
        final Pedido estado_domi = Pedido.fromJson(jsonData);


      }*/



    }).catchError((context) {
      print(context);
      print("error...");
      throw UserNotFoundException();
    });
  }
}

class UserNotFoundException implements Exception {}
