
import 'package:domiciliarios_app/Modelo/LoginModel.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UsuarioModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'SharedPreferencesServicio.dart';

class AuthAPIServicio {
  //Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
  Future<User> login2(LoginRequestModel requestModel) async {
    //String url = "https://reqres.in/api/login";
    String url = "http://logintest.satiws.com/api/Login/Login";

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {

      print(response.body);
      print("bbb");

      final Map<String, dynamic> responseData = json.decode(response.body);
      //var userData = responseData['data'];
      //User authUser = User.fromJson(userData);
      User authUser = User.fromJson(responseData);

      UserPreferences().saveUser(authUser);
      return authUser;
      /*return LoginResponseModel.fromJson(
        json.decode(response.body),
      );*/


    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<Salida> login(String email, String password) async {
    //String url = "http://domitest.satiws.com/api/DomiApp/Listar/";
    String url = "http://logintest.satiws.com/api/Login/Login";

    User authUser;
    String mensaje = "";

    print(url);
    print("LOGIN");


    //Map param = {"email": email, "password": password};
    Map param = {"user": email, "passwd": password, "tipoUsua": "DOM", "marca": "FRISBY"};

    String jsonString = json.encode(param);

    print(param);

    //final response = await http.post(url, body: loginRequestModel.toJson());
    final response = await http.post(url,  headers: {"Accept": "text/plain", "Content-Type": "application/json"},   body: jsonString);
    print("Estado");
    print(response.statusCode);
    if (response.statusCode == 200 ) {
      print(response.body);

      final Map<String, dynamic> responseData = json.decode(response.body);


      if(responseData['salida']["codi"] == 0){
        var parts = responseData['salida']["mens"].split('-');
        mensaje = parts[1].trim();
      }

      Salida respuesta =  new Salida(responseData['salida']["codi"], mensaje);

      print("Salida");
      print(respuesta.code);

      if( respuesta.code == 1 ){
        authUser = User.fromJson(responseData);

        print(authUser.name);

        if(authUser.token != ""){
          UserPreferences().saveUser(authUser);
        }
      }

      return respuesta;
      /*return LoginResponseModel.fromJson(
        json.decode(response.body),
      );*/

    }
    else if ( response.statusCode == 400) {
      print("bbb");

      final Map<String, dynamic> responseData = json.decode(response.body);

      Salida respuesta =  new Salida(responseData['salida']["codi"], "En el envio de datos");

      return respuesta;
    }

    else {
      throw Exception('Failed to load data!');
    }
  }
}