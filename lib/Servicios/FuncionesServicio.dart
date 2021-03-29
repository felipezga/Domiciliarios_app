/*
import 'dart:convert';

import 'package:flutter/material.dart';

import 'AuthServicio.dart';

class Funciones  {
  /*final _email = new BehaviorSubject<String>();
  final _password = new BehaviorSubject<String>();
  final _errorMessage = new BehaviorSubject<String>();
*/




  var authInfo;
  // rgister
  /*dynamic register(BuildContext context) async {
    authInfo = AuthService();

    final res = await authInfo.register(_email.value, _password.value);
    final data = jsonDecode(res) as Map<String, dynamic>;

    if (data['status'] != 200) {
     // addError(data['message']);
    } else {
      AuthService.setToken(data['token'], data['refreshToken']);
      Navigator.pushNamed(context, '/home');
      return data;
    }
  }*/

  // login
  dynamic login(BuildContext context, _email _password) async {
    authInfo = AuthService();

    final res = await authInfo.login(_email, _password);
    final data = jsonDecode(res) as Map<String, dynamic>;

    if (data['status'] != 200) {
      //addError(data['message']);
    } else {
      AuthService.setToken(data['token'], data['refreshToken']);
      Navigator.pushNamed(context, '/home');
      return data;
    }
  }

  // close streams
  dispose() {
    _email.close();
    _password.close();
    _errorMessage.close();
  }
}*/