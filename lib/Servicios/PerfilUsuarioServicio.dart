import 'dart:convert';

import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:http/http.dart';

class PerfilUserRepository {
  Future<PerfilUser> fetchUser(String userName) async {
    String api = 'https://api.github.com/users/${userName}';
    return await get(api).then((data) {
      final jsonData = json.decode(data.body);

      if (jsonData['message'] == "Not Found") {
        throw UserNotFoundException();
      } else {
        final PerfilUser profile = PerfilUser.fromJson(jsonData);

        /*final profile = PerfilUser(
          name: jsonData['login'],
          bio: jsonData['bio'] ?? "",
          followers: jsonData['followers'],
          following: jsonData['following'],
          image: jsonData['avatar_url'],
          public_repos: jsonData['public_repos'],
        );*/
        return profile;
      }
    }).catchError((context) {
      throw UserNotFoundException();
    });
  }
}

class UserNotFoundException implements Exception {}
