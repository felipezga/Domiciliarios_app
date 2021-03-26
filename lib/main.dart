import 'package:flutter/material.dart';
import 'Modelo/LoginModel.dart';
import 'Paginas/Login.dart';
import 'Paginas/Mapa.dart';
import 'Paginas/Home.dart';
import 'Paginas/prueba.dart';
import 'Servicios/SharedPreferencesServicio.dart';


void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<App>{
  int _paginaActual = 0;

  List<Widget> paginas = [
    //Login(),
    LoginPage(),
    PaginaHome(),
    //Restaurante(),
  ];

  Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: paginas[_paginaActual],
      home: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.data.token == null)
                  return LoginPage();
                else
                  UserPreferences().removeUser();
                //return Welcome(user: snapshot.data);
                return Mapa();
            }
          }),
      routes: <String, WidgetBuilder>{
       // "/restaurante" : ( context) => Restaurante(opcion: 1),
       // Restaurante.route: ( context) =>  Restaurante(opcion: 2),
        Mapa.route : ( context) => Mapa(),
        //"/contacto" : ( context) => Contacto(),
        "/contacto" : ( context) => PluginScaleBar(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}


