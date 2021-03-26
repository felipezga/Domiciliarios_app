
import 'package:domiciliarios_app/Modelo/LoginModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'SharedPreferencesServicio.dart';

class APIServicio {
  //Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
  Future<User> login(LoginRequestModel requestModel) async {
    String url = "https://reqres.in/api/login";

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
}