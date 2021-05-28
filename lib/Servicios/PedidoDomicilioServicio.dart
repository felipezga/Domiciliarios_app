import 'dart:convert';

import 'package:domiciliarios_app/Modelo/AsignarOrdenModel.dart';
import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

class PedidoDomiclioRepository {

  static const _baseUrl = "https://10.0.2.2:5001/api/DomiApp/Listar/";

  Future<List<Pedido>> fetchPedidoUser(String userName) async {
    //String api = 'https://api.github.com/users/${userName}';



    //String api = 'http://bengkelrobot.net:8001/${userName}';
    String api = _baseUrl+userName;
    print(api);
    print("appaa");
    var data = await http.get(api);
    //return await get(api).then((data) {
      print(data);
      print("dataaa");


      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        print(jsonData);
        print("jsonnnnn");
        print(jsonData['ordenes']);
        // If the call to the server was successful, parse the JSON

        List<Pedido> pedidos = PedidosFromJson(jsonData['ordenes']);
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



    /*}).catchError((context) {
      print(context);
      print("error...");
      throw UserNotFoundException();
    });*/
  }




  //Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
  Future<bool> asignarPedido(List<asignarOrden> requestModel) async {
    String url = "https://reqres.in/api/login";
    bool resul = false;
    print('responsa');
    final response = await http.post(url, body: requestModel);
    print('1234');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {

    print(response.body);
    print("bbb");

    final responseData = json.decode(response.body);
    resul = responseData.codi;

    return resul;

    } else {

      print('problem');
      print(response.body);
    throw Exception('Failed to load data!');
    }
  }

}

class UserNotFoundException implements Exception {}
