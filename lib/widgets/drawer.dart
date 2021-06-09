import 'package:domiciliarios_app/Paginas/Domicilios.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:domiciliarios_app/Paginas/Mapa.dart';
import 'package:domiciliarios_app/Paginas/Configuraciones.dart';
import 'package:domiciliarios_app/Paginas/PerfilUsuario.dart';
import 'package:domiciliarios_app/Servicios/SharedPreferencesServicio.dart';
import 'package:flutter/material.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/Mapa.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/Restaurante.dart';
//import 'package:restaurantes_tipoventas_app/Paginas/prueba.dart';

//import '../Paginas/prueba.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // place the logout at the end of the drawer
        children: <Widget>[
          Flexible(
              child: ListView(
                  //shrinkWrap: true,
                  children: <Widget>[
                /*DrawerHeader(
          child: Center(
            child: const Text('Felipe Rios'),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),*/
                _createHeader(),

                ListTile(
                  leading: Icon(Icons.perm_identity),
                  title: const Text('Perfil '),
                  //selected: currentRoute == Mapa.route,
                  onTap: () {
                    Navigator.popAndPushNamed(context, PerfilUsuario.route);
                    //  Navigator.pushReplacementNamed(context, Mapa.route);
                  },
                ),

                Divider(),

                ListTile(
                  leading: Icon(Icons.map),
                  title: const Text('Mapa'),
                  //selected: currentRoute == Mapa.route,
                  onTap: () {
                    Navigator.popAndPushNamed(context, Mapa.route);
                    //  Navigator.pushReplacementNamed(context, Mapa.route);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner),
                  title: const Text('Escanear'),
                  //selected: currentRoute == Restaurante.route,
                  onTap: () {
                    //Navigator.pushReplacementNamed(context, Restaurante.route);
                    //Navigator.popAndPushNamed(context, '/escaner');
                    /*Navigator.popAndPushNamed(context, EscanearFactura.route, arguments: EscanearFactura(
                       "liperi",
                    ));*/

                    Navigator.popAndPushNamed(
                      context,
                      EscanearFactura.route,
                      //ExtractArgumentsScreen.routeName,
                      arguments:  "asignar"
                      //'Extract Arguments Screen',
                      //'This message is extracted in the build method.',
                      ,
                    );


                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.motorcycle),
                  title: const Text('Domicilios '),
                  //selected: currentRoute == Mapa.route,
                  onTap: () {
                    Navigator.popAndPushNamed(context, Domicilios.route);
                    //  Navigator.pushReplacementNamed(context, Mapa.route);
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
                //Divider(),
              ])),
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
              //Navigator.pushReplacementNamed(context, Restaurante.route);
              //Navigator.pushNamed(context, Restaurante.route);
            },
          ),
        ]),
  );
}

Widget _createHeader() {
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
            child: Text("Felipe Rios",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ))),
        Image.asset('images/icono_frisby.png'),
      ]));
}
