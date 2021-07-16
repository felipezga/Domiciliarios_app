import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/SeleccionBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Bloc/UserLocationBloc.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class ArgumentsHistorial {
  final String message;
  final List<Pedido> ordenes;

  ArgumentsHistorial(this.message, this.ordenes);
}

class HistorialMapa extends StatelessWidget{
  static const String route = '/historialMapa';
  final ArgumentsHistorial arguments;

  HistorialMapa(this.arguments);

  @override
  Widget build(BuildContext context) {
    return /*BlocProvider(
      create: (context) => PedidoBloc(pedidoRepo: PedidoDomiclioRepository()),*/
      MultiBlocProvider(
        providers: [
          BlocProvider<PedidoBloc>(
            create: (BuildContext context) =>  PedidoBloc(pedidoRepo: PedidoDomiclioRepository()),
          ),
          BlocProvider<LocationBloc>(
            create: (BuildContext context) => LocationBloc()..add(LocationStarted()),
          ),

          BlocProvider<SeleccionBloc>(
              create: (context) {
                return SeleccionBloc();
              })

        ],
        child: HistorialMapaState( arguments),

      );

  }
}

class HistorialMapaState extends StatefulWidget{

  final ArgumentsHistorial arguments;

  HistorialMapaState( this.arguments ) : super();
  RutasMapa createState() => RutasMapa();
}

class RutasMapa extends State<HistorialMapaState> {

  List<Pedido> pedidosAsignados = [];
  String idRuta;
  List<Pedido> pedidosLatLong = [];
  List<Marker> markers = [];

  void getDropDownItem( pedido){
    context.read<PedidoBloc>().add(EntregarPedido( pedido));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //double _latitude;
  //double _longitude;
  bool _isGettingLocation;
  String mensBoton = "Iniciar";
  int contador;

  Pedido pedidoSeleccionado;


  List<LatLng> points = [];

  List<LatLng> tappedPoints = [];
  LatLng casa;

  static const darkLink = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}@2x.png';
  static const lightLink = 'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png';
  //https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png



  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    //_controller.dispose();
    //_botonesWidgetBloc.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    idRuta = widget.arguments.message;
    pedidosLatLong = widget.arguments.ordenes;
    print("holss");
    print(pedidosLatLong.length);

    for( Pedido pedLatLong in pedidosLatLong){

      markers.add(
          Marker(
            width: 50.0,
            height: 50.0,
            //point: LatLng(_latitude, _longitude),
            point: LatLng(pedLatLong.latitud, pedLatLong.longitud),
            builder: (ctx) =>
                Container(
                    child: Image(
                      image: new AssetImage("images/entregado.png"),
                      width: 20,
                      height: 20,
                      color: null,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    )
                  /*ImageIcon(
                                          AssetImage('images/frisby.png'),
                                            color:Colors.red,
                                            size: 20
                                        )*/
                  //Icon(Icons.motorcycle_rounded),
                ),
          )

          );

    }

    _isGettingLocation = true;
    //_obtenerLocationEstado(mens_boton, "", "Finalizar");
    contador = 0;

    _loadPedidoUsuario();

  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (contextTheme, theme) {

          var isDarkMode = theme.getThemeState;
          print(_isGettingLocation);
          print("bebeb");

          return Scaffold(
            appBar: AppBar(
              leading: Container(
                color: theme.getTheme.appBarTheme.color,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: theme.getTheme.hoverColor,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              title: Text(
                "RUTA: " + idRuta,
                style: TextStyle(
                  color: theme.getTheme.hoverColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: theme.getTheme.appBarTheme.color,
            ),
            //drawer: buildDrawer(context, Configuraciones.route),
            body: marcarOrdenes( isDarkMode ),
          );



        }
    );


  }

  marcarOrdenes( isDarkMode){

    return
      BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationInitial) {
            return Center(child: Text('Cargando Localizacion'));
          }
          if (state is LocationLoadSuccess) {
            final lat = state.position.latitude;
            final lon = state.position.longitude;

/*
            var markers = <Marker>[
              Marker(
                width: 50.0,
                height: 50.0,
                //point: LatLng(_latitude, _longitude),
                point: LatLng(state.position.latitude, state.position.longitude),
                builder: (ctx) =>
                    Container(
                        child: Image(
                          image: new AssetImage("images/entregado.png"),
                          width: 20,
                          height: 20,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        )
                      /*ImageIcon(
                                          AssetImage('images/frisby.png'),
                                            color:Colors.red,
                                            size: 20
                                        )*/
                      //Icon(Icons.motorcycle_rounded),
                    ),
              ),
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng( 4.8244811000000003, -75.680027300000001),
                builder: (ctx) => Container(
                  child: Image(
                    image: new AssetImage("images/entregado.png"),
                    width: 20,
                    height: 20,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng(	4.8130037999999997, -75.670693099999994,),
                builder: (ctx) => Container(
                  child: Image(
                    image: new AssetImage("images/entregado.png"),
                    width: 20,
                    height: 20,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng(4.8204811000000003, -75.670693099999994),
                builder: (ctx) => Container(
                  child: Image(
                    image: new AssetImage("images/entregado.png"),
                    width: 20,
                    height: 20,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: casa,
                builder: (ctx) => Container(
                  child: Icon(Icons.home),
                ),
              )
            ];*/



            return
              Stack(
                  children: [
                    Scaffold(
                        key: _scaffoldKey,
                        body: FlutterMap(
                          options: MapOptions(
                            center: LatLng(lat, lon),
                            zoom: 14.0,
                            maxZoom: 18.0,
                            minZoom: 12.0,
                            //onTap: _handleTap
                          ),
                          layers: [
                            TileLayerOptions(
                                urlTemplate: isDarkMode
                                    ? darkLink
                                    : lightLink,
                                //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c']
                            ),
                            PolylineLayerOptions(
                              polylines: [
                                Polyline(
                                    points: points,
                                    strokeWidth: 4.0,
                                    color: Colors.red),
                              ],
                            ),
                            MarkerLayerOptions(
                              markers: markers
                            ),
                          ],
                        )
                    ),
                    BlocBuilder<PedidoBloc, PedidoState>(
                        builder: (BuildContext context, PedidoState state) {
                          if (state is PedidoError) {
                            final error = state.error;
                            //String message = '${error.message}\nTap to Retry.';
                            return Text(error);
                          }
                          if (state is PedidoLoaded) {
                            List<Pedido> pedidosAsignados = state.rutaPedido.pedidos;
                            if(pedidosAsignados.length > 0){
                              //dropdownValue = state.pedido[0];
                              //_obtenerLocationEstado( "Iniciar" , "PEDIDO PREPARADO", "Finalizar");
                              //_obtenerLocationEstado(mens_boton, "", "Finalizar");

                              //context.read<SeleccionBloc>().add(SeleccionarEvent( dropdownValue));
                              context.read<SeleccionBloc>().add(SeleccionarEvent( state.rutaPedido.pedidos[0]));

                              //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  "PREPARADO", descripcionTracking: "PRODUCTO PREPARADO", listaTracking: estaDomi));
                              return Text( "" );

                            }

                          }
                          if (state is PedidoLoading ){
                            return Loading();
                          }

                          return Text("Pedido");
                        }),


                  ]
              )
            ;
          }
          return Center(child: CircularProgressIndicator());
        },
      );
  }

  _loadPedidoUsuario() async {

    //context.read<PedidoBloc>().add(GetPedidoUser("mojombo"));
    //context.read<PedidoBloc>().add(GetPedidoUser("herbivora"));
    context.read<PedidoBloc>().add(GetPedidoUser());
    print("Pedido Cargado");
  }



}


