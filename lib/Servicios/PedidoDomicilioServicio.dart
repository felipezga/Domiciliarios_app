import 'dart:convert';

import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/RutaModel.dart';
import 'package:domiciliarios_app/Modelo/RutaPedidoEstado.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';

import 'package:http/http.dart' as http;
import '../Configuraciones.dart';

class PedidoDomiclioRepository {

  //static const _baseUrl = "https://10.0.2.2:5001/api/DomiApp/Listar/";


  Future<RutaPedido> fetchPedidoUser(String userName) async {
    //String api = 'https://api.github.com/users/${userName}';

    print(userName);
    print("USERNAME");


    //String api = 'http://bengkelrobot.net:8001/${userName}';
    String api = url_api_domiciliario+listar_pedidos+userName;
    print(api);
    print(userName);
    print("appaa");
    var data = await http.get(api);
    //return await get(api).then((data) {
      print(data.body);
    print(data.statusCode);
      print("dataaa");


      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        print(jsonData);
        print("jsonnnnn");
        print(jsonData['ordenes']);
        // If the call to the server was successful, parse the JSON

        List<Pedido> pedidos = pedidosFromJson(jsonData['ordenes']);
        RutaPedido rutaPed = RutaPedido(jsonData['idRuta'], jsonData['estaRuta'], pedidos );
        return rutaPed;
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

  Future<List<RutaPedido>> historialRutaOrdeUser(String userName) async {
    //String api = 'https://api.github.com/users/${userName}';

    print(userName);
    print("USERNAME");

    List<RutaPedido> rutasPed = [];


    //String api = 'http://bengkelrobot.net:8001/${userName}';
    String api = url_api_domiciliario+historial_ruta_orde+userName;
    print(api);
    print(userName);
    print("appaa");
    var data = await http.get(api);
    //return await get(api).then((data) {
    print(data.body);
    print(data.statusCode);
    print("dataaa");


    if (data.statusCode == 200) {
      final jsonData = json.decode(data.body);

      print(jsonData);
      print("jsonnnnn");
      print(jsonData['rutas']);

      for(var ruta in jsonData['rutas'] ){

        List<Pedido> pedidos = pedidosFromJson(ruta['ordenes']);
        rutasPed.add( RutaPedido(ruta['idRuta'], ruta['estaRuta'], pedidos ) ) ;

      }

      return rutasPed;
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



  Future<Salida> asignarPedido(Ruta requestModel) async {
    //String url = "https://10.0.2.2:5001/api/DomiApp/AsignarOrden";
    String url = url_api_domiciliario+asignar_pedido;
    Salida salida;

    print('Servicio Asignacion');
    print(requestModel.usuaId);
    print(requestModel.ordenes[0].numero);

    String jsonString = json.encode(requestModel);
    //String jsonString ='[{"id":2,"prefijo":"G471","numero":598240,"usuaId":1}]' ;
    print(jsonString);

    final response = await http.post( url,
                                      headers: {"Accept": "text/plain", "Content-Type": "application/json"},
                                      body: jsonString );

    print('Responde respuesta');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 ) {

    final responseData = json.decode(response.body);

    salida = Salida(responseData['codi'], responseData['mens']);
    return salida;

    }
    else if ( response.statusCode == 400) {
      print("bbb");

      final Map<String, dynamic> responseData = json.decode(response.body);

      Salida respuesta =  new Salida(responseData['salida']["codi"], "Problema al asignar el pedido");

      return respuesta;
    }

    else {

      print('problem');
      print(response.body);
      throw Exception('Failed to load data!');
    }
  }

  Future<Salida> ActuEstaOrde(List<Orden> requestModel) async {
    //String url = "https://10.0.2.2:5001/api/DomiApp/Actulizar";
    String url = url_api_domiciliario+actualizar_pedido;
    Salida salida;


    print(url);
    print('responsa');

    String jsonString = json.encode(requestModel);
    //String jsonString ='[{"id":2,"prefijo":"G471","numero":598240,"usuaId":1}]' ;

    print(jsonString);

    //print(requestModel[0].prefijo);
    final response = await http.post(url,  headers: {
      "Accept": "text/plain",
      "Content-Type": "application/json"
    }, body: jsonString);
    print('Responde respuesta');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {

      print(response.body);
      print("bbb");

      final responseData = json.decode(response.body);

      salida = Salida(responseData['codi'], responseData['mens']);
      return salida;

    } else {

      print('problem');
      print(response.body);
      //return resul;
      throw Exception('Failed to load data!');
    }
  }

  Future<Salida> ActuEstaRuta(int idR, String nuevoEstado) async {
    //String url = "https://10.0.2.2:5001/api/DomiApp/Actulizar";
    String url = url_api_domiciliario+actualizar_ruta;
    Salida salida;


    print(url);
    print('responsa');


    Map tempParam = {"id_Ruta": idR, "estado": nuevoEstado};
    var param = json.encode(tempParam);

    print(param);

    //print(requestModel[0].prefijo);
    final response = await http.post(url,  headers: {
      "Accept": "text/plain",
      "Content-Type": "application/json"
    }, body: param);
    print('Responde respuesta');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {

      print(response.body);
      print("bbb");

      final responseData = json.decode(response.body);

      salida = Salida(responseData['codi'], responseData['mens']);
      return salida;

    } else {

      print('problem');
      print(response.body);
      //return resul;
      throw Exception('Failed to load data!');
    }
  }

  Future<Salida> reasignarPedido(List<Orden> requestModel) async {
    //String url = "https://10.0.2.2:5001/api/DomiApp/Actulizar";
    String url = url_api_domiciliario+reasignar_pedido;
    Salida salida;


    print(url);
    print('responsa');

    String jsonString = json.encode(requestModel);
    //String jsonString ='[{"id":2,"prefijo":"G471","numero":598240,"usuaId":1}]' ;

    print(jsonString);

    //print(requestModel[0].prefijo);
    final response = await http.post(url,  headers: {
      "Accept": "text/plain",
      "Content-Type": "application/json"
    }, body: jsonString);
    print('Responde respuesta');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {

      print(response.body);
      print("bbb");

      final responseData = json.decode(response.body);

      salida = Salida(responseData['codi'], responseData['mens']);
      return salida;

    } else {

      print('problem');
      print(response.body);
      //return resul;
      throw Exception('Failed to load data!');
    }
  }

}

class UserNotFoundException implements Exception {}
