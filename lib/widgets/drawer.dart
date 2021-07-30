import 'package:domiciliarios_app/Modelo/ArgumentsModel.dart';
import 'package:domiciliarios_app/Modelo/UsuarioModel.dart';
import 'package:domiciliarios_app/Paginas/Domicilios.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:domiciliarios_app/Paginas/Mapa.dart';
import 'package:domiciliarios_app/Paginas/Configuraciones.dart';
import 'package:domiciliarios_app/Paginas/PerfilUsuario.dart';
import 'package:domiciliarios_app/Paginas/ReasignarEntregas.dart';
import 'package:domiciliarios_app/Paginas/RutaOrdenes.dart';
import 'package:domiciliarios_app/Paginas/ScanDatawedge.dart';
import 'package:domiciliarios_app/Servicios/SharedPreferencesServicio.dart';
import 'package:flutter/material.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/Mapa.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/Restaurante.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/prueba.dart';

//import '../Paginas/prueba.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  Future<User> getUserData() => UserPreferences().getUser();
  return Drawer(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // place the logout at the end of the drawer
        children: <Widget>[
          Flexible(
              child: ListView(
                  children: <Widget>[
                    _createHeader( getUserData() ),
                    ListTile(
                      leading: Icon(Icons.perm_identity),
                      title: const Text('Perfil Usuario'),
                      //selected: currentRoute == Mapa.route,
                      onTap: () {
                        Navigator.popAndPushNamed(context, PerfilUsuario.route);
                        //  Navigator.pushReplacementNamed(context, Mapa.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: const Text('Mapa '),
                      //selected: currentRoute == Mapa.route,
                      onTap: () {
                        Navigator.popAndPushNamed(context, Mapa.route);
                        //  Navigator.pushReplacementNamed(context, Mapa.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.star_border_purple500_sharp),
                      title: const Text(' Ruta | Ordenes'),
                      //selected: currentRoute == Mapa.route,
                      onTap: () {
                        Navigator.popAndPushNamed(context, RutaOrdenes.route);
                        //  Navigator.pushReplacementNamed(context, Mapa.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.light_mode),
                      title: const Text('Asignar Ordenes  |  Laser'),
                      //selected: currentRoute == Mapa.route,
                      onTap: () {
                        Navigator.popAndPushNamed(context, ScannerLaser.route, arguments:  Arguments("asignar", [] ) );
                        //  Navigator.pushReplacementNamed(context, Mapa.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.qr_code_scanner),
                      title: const Text('Asignar Ordenes  |  Camara'),
                      //selected: currentRoute == Restaurante.route,
                      onTap: () {
                        //Navigator.pushReplacementNamed(context, Restaurante.route);
                        //Navigator.popAndPushNamed(context, '/escaner');
                        /*Navigator.popAndPushNamed(context, EscanearFactura.route, arguments: EscanearFactura(
                           "liperi",
                        ));*/

                        Navigator.popAndPushNamed( context, EscanearFactura.route, arguments:  Arguments("asignar", [] ) );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.share),
                      title: const Text('Reasignar Ordenes'),
                      //selected: currentRoute == Restaurante.route,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Reasignacion.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.history),
                      title: const Text('Historial Domicilios '),
                      //selected: currentRoute == Mapa.route,
                      onTap: () {
                        Navigator.popAndPushNamed(context, Domicilios.route);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: const Text('Configuraciones'),
                      //selected: currentRoute == Restaurante.route,
                      onTap: () {
                        //Navigator.pushReplacementNamed(context, Restaurante.route);
                        Navigator.popAndPushNamed(context, Configuraciones.route);
                      },
                    ),
                  ]
              )
          ),
          ListTile(
            leading: Icon(Icons.arrow_back_outlined),
            title: const Text('Salir'),
            /*trailing: Text(
              "Version 0.0.1",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),*/
            //dense: true,
            //selected: currentRoute == Restaurante.route,
            onTap: () {
              UserPreferences().removeUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ]
    ),
  );
}

Widget _createHeader( Future<User> _session ) {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        /*image: DecorationImage(
              fit: BoxFit.fitWidth,
              image:  AssetImage('images/icono_frisby.png')),*/
        color: Colors.red,
      ),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 8.0,
            left: 12.0,
            child:
            FutureBuilder(
              //future: getUserData(),
                future: _session,
                builder: (context, snapshot) {
                  print("snapshot");
                  print(snapshot.data);
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    return Text("");

                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if (snapshot.data.token == "")
                        return Text("");
                      else
                        return Text(snapshot.data.name != null ? snapshot.data.name : "" ,
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ));
                      //return Welcome(user: snapshot.data);
                      //return Mapa();
                  }
                })

            ),
        Image.asset('images/icono_frisby.png'),
      ]));
}
