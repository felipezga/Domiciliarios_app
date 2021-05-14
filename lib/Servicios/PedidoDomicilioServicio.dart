import 'dart:convert';

import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:http/http.dart';

class PedidoDomiclioRepository {
  Future<Pedido> fetchPedidoUser(String userName) async {
    String api = 'https://api.github.com/users/${userName}';
    return await get(api).then((data) {
      final jsonData = json.decode(data.body);

      if (jsonData['message'] == "Not Found") {
        throw UserNotFoundException();
      } else {
        final Pedido estado_domi = Pedido.fromJson(jsonData);

        return estado_domi;
      }
    }).catchError((context) {
      throw UserNotFoundException();
    });
  }
}

class UserNotFoundException implements Exception {}
