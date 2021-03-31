import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Paginas/Configuraciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'Modelo/LoginModel.dart';
import 'Paginas/Login.dart';
import 'Paginas/Mapa.dart';
import 'Paginas/Home.dart';
import 'Paginas/prueba.dart';
import 'Servicios/SharedPreferencesServicio.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<App>{
  int _paginaActual = 0;

  final _pageOptions = [

    BlocProvider(
      create: (context) => ThemeBloc(),
      child: Configuraciones(),
    ),
  ];

  List<Widget> paginas = [
    //Login(),
    LoginPage(),
    PaginaHome(),
    //Restaurante(),
  ];

  Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),*/
      theme: ThemeData.dark(),
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
        Configuraciones.route : ( context) => Configuraciones(pageOptions: _pageOptions),
        "/contacto" : ( context) => PluginScaleBar(),
        '/login': (context) => LoginPage(),
      },
    );*/

    return BlocProvider(
        create: (_) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, ThemeState>(builder: (_, theme) {

          return  AndroidMaterialApp( theme: theme.getTheme, pageOptions: _pageOptions);
        })
    );
  }
}


//https://morioh.com/p/67c610cc30f7