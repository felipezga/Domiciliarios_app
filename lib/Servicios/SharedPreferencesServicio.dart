
import 'package:domiciliarios_app/Modelo/UsuarioModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //prefs.setInt("userId", user.userId);
    prefs.setString("userId", user.userId);
    prefs.setString("name", user.name);
    prefs.setString("docIdent", user.docIdent);
    prefs.setString("token", user.token);
    prefs.setString("salida", user.salida);

    print("SHARED PREFERENCES OK");

    //return prefs.commit();
    Future<bool> commit() async => true;
    return commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("userId");
    String name = prefs.getString("name");
    String docIdent = prefs.getString("docIdent");
    String token = prefs.getString("token");
    String error = prefs.getString("salida");

    return User(
        userId: userId,
        name: name,
        docIdent: docIdent,
        token: token,
        salida: error);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("docIdent");
    prefs.remove("token");
    prefs.remove("salida");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}