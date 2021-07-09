import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/RutaModel.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/ErrorText.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'HistorialMapa.dart';

class Domicilios extends StatelessWidget {

  static const String route = '/domicilios';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      //create: (context) => DomicilioBloc(domicilioRepo: DomicilioServices()),
      create: (BuildContext context) =>  PedidoBloc(pedidoRepo: PedidoDomiclioRepository()),
      child: DomiciliosScreen(),
    );
  }
}

class DomiciliosScreen extends StatefulWidget {
  @override
  _DomicilioState createState() => _DomicilioState();
}

class _DomicilioState extends State<DomiciliosScreen> {
  //

  @override
  void initState() {
    super.initState();
    //_loadTheme();
    _loadDomicilios();
  }

  /*_loadTheme() async {
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: Preferences.getTheme()));
  }*/

  _loadDomicilios() async {
    print("load");
    //context.read<DomicilioBloc>().add(DomicilioEvents.fetchDomicilios);
    context.read<PedidoBloc>().add(GetPedidoUser());
    print("loadeee");
  }

  /*_setTheme(bool darkTheme) async {
    AppTheme selectedTheme =
    darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme;
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: selectedTheme));
    Preferences.saveTheme(selectedTheme);
  }*/

  List<Ruta> rutas = <Ruta>[
    new Ruta(usuaId: 'Ruta1', ordenes: []),
    new Ruta(usuaId:'Ruta2', ordenes:  []),
    new Ruta(usuaId: 'Ruta3', ordenes: []),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.red,),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
          ),
          //automaticallyImplyLeading: false,
          title: Text(
            'HISTORIAL ENTREGAS',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, Domicilios.route),
        body: Container(
          child: _body(),
        ),
      );
    });
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<PedidoBloc, PedidoState>(
            builder: (BuildContext context, PedidoState state) {
              if (state is PedidoError) {
                final error = state.error;
                String message = error+'\nTap to Retry.';
                return ErrorTxt(
                  message: message,
                  onTap: _loadDomicilios(),
                );
              }
              if (state is PedidoLoaded) {
                List<Pedido> historialPedidos = state.rutaPedido.pedidos;
                //List<Domicilio> albums = state.domicilios;
                return _list(historialPedidos, rutas);
              }
              return Loading();
            }),
      ],
    );
  }

  Widget _list(List<Pedido> pedidos, rutas) {
    return Expanded(
      child: ListView.builder(
        itemCount: rutas.length,
        itemBuilder: (_, index) {
          //Pedido p = pedidos[index];
          Ruta r = rutas[index];
          //return ListRow(pedido: p);
          return ListRow(pedidos: pedidos, ruta: r,);
        },
      ),
    );
  }
}





class ListRow extends StatelessWidget {
  //
  final List<Pedido> pedidos;
  final Ruta ruta;
  ListRow({this.pedidos, this.ruta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            //key: PageStorageKey<NameBean>(bean),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                      ruta.usuaId,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )
                  ),
                ),
                Text(
                    "23:43",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )
                ),

              ],
            ),
            subtitle: Text(ruta.usuaId ),
            children: pedidos.map<Widget>((ped) =>
              ListTile(
                leading: Icon(Icons.volunteer_activism, size: 50, color: Colors.red,),
                title: Text(ped.name.toString()),
                subtitle: Text(ped.id.toString()),
                trailing: Text(ped.estado.toString()),
              ),
              //Text( pedido.numero.toString()),
              //Divider(),

            ).toList(),
            leading: IconButton(
                icon: new Icon(Icons.location_history, color: Colors.red, size: 45,),
                highlightColor: Colors.pink,
                onPressed: (){
                  print("No fuimos");
                  Navigator.push( context,
                    new MaterialPageRoute(
                      builder: (context) => new HistorialMapa(),
                    ),
                  );

                  //Navigator.popAndPushNamed(context, HistorialMapa.route);


                }
            ),

            /*CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(ruta.fecha.substring(0,1),style: TextStyle(color: Colors.white),),
            ),*/
    )


        ],
      ),
    );
  }
}



