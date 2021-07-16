import 'dart:async';
//import 'dart:ffi';

import 'package:domiciliarios_app/Bloc/BotonesTrackingBloc.dart';
import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/SeleccionBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Bloc/TrackingBloc.dart';
import 'package:domiciliarios_app/Bloc/UserLocationBloc.dart';
import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:domiciliarios_app/Servicios/NotificacionPushFirebase.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/AlertConfirmacion.dart';
import 'package:domiciliarios_app/widgets/DialogNovedad.dart';
import 'package:domiciliarios_app/widgets/DropdownButtonOrdenes.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/TimeLine.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:restaurantes_tipoventas_app/widgets/drawer.dart';

class Mapa extends StatelessWidget{
  static const String route = '/mapa';

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
          /*BlocProvider<TrackingBloc>(
              create: (context) {
            return TrackingBloc();
          }),*/
          BlocProvider<BotonesBloc>(
              create: (context) {
                return BotonesBloc();
              })
          ,
          BlocProvider<SeleccionBloc>(
              create: (context) {
                return SeleccionBloc();
              })
        ],
        child: new Scaffold(
          //appBar: AppBar(title: new Text("MAPA"),),
          backgroundColor: Colors.grey[200],
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu, color: Colors.red,),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  }
              )
          ),
          drawer: buildDrawer(context, Mapa.route),
          body: MapaState(),
        ),
    );
  }
}

class MapaState extends StatefulWidget{
  MapaState() : super();
  _AppState createState() => _AppState();
}

class _AppState extends State<MapaState> {
//class _AppState extends State<mapaState> with TickerProviderStateMixin {

  BotonesBloc _botonesWidgetBloc;
  //String _locationMessage = "";
  //String _currentAddress;

  // Default Drop Down Item.
  String dropdownValue = '-';
  List<Pedido> pedidosAsignados = [];
  List<Pedido> pedidosTracking = [];
  String estadoRuta;
  int idRuta;


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

  //int _counter = 0;
  //AnimationController _controller;
  //int levelClock = 180;

  List<EstadoDomiciliario> estaDomi = [];
  List<LatLng> points = [];

  List<LatLng> tappedPoints = [];
  LatLng casa;

  static const darkLink = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}@2x.png';
  static const lightLink = 'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png';
  //https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png


  //Marker _marker;
  //Timer _timer;
  //int _markerIndex = 0;

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    //_controller.dispose();
    _botonesWidgetBloc.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //LatLng _new = LatLng(33.738045, 73.084488);
    //points.add(_new);

    _isGettingLocation = true;
    //_obtenerLocationEstado(mens_boton, "", "Finalizar");
    contador = 0;

    /*/_timer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        _getCurrentLocation();
      });
    });*/



    /*_controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );*/

    /*final notificacionServicio = new NotificacionesPush();
    notificacionServicio.initNotification();*/

    _loadPedidoUsuario();


  }

  @override
  Widget build(BuildContext context) {

    _botonesWidgetBloc = BlocProvider.of<BotonesBloc>(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          var isDarkMode = theme.getThemeState;

          print(_isGettingLocation);
          print("bebeb");
          return
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationInitial) {
                  return Center(child: Text('Cargando Localizacion'));
                }
                if (state is LocationLoadSuccess) {
                  final lat = state.position.latitude;
                  final lon = state.position.longitude;
                  return
                    Stack(
                        children: [
                          Scaffold(
                              key: _scaffoldKey,
                              body: FlutterMap(
                                options: MapOptions(
                                    center: LatLng(lat, lon),
                                    zoom: 16.0,
                                    maxZoom: 18.0,
                                    minZoom: 2.0,
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
                                    markers: [
                                      Marker(
                                        width: 40.0,
                                        height: 40.0,
                                        //point: LatLng(_latitude, _longitude),
                                        point: LatLng(state.position.latitude, state.position.longitude),
                                        builder: (ctx) =>
                                            Container(
                                                child: Image(
                                                  image: new AssetImage("images/frisby.png"),
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
                                        width: 80.0,
                                        height: 80.0,
                                        point: casa,
                                        builder: (ctx) => Container(
                                          child: Icon(Icons.home),
                                        ),
                                      )
                                    ],
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
                                  estadoRuta = state.rutaPedido.estado;
                                  idRuta = state.rutaPedido.id;
                                  //List<Pedido> pedidosAsignados = state.rutaPedido.pedidos.where((element) => element.numero == estadoRuta );

                                  print("empezamos");

                                  //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  "PREPARADO", descripcionTracking: "PRODUCTO PREPARADO", listaTracking: estaDomi));

                                  if(state.rutaPedido.pedidos.length > 0){
                                    if(estadoRuta == "RESTAURANTE"){
                                      print("en rest");
                                      pedidosAsignados = state.rutaPedido.pedidos;
                                      pedidosTracking = state.rutaPedido.pedidos;
                                      _botonesWidgetBloc.add(EventIniciarBoton());
                                      context.read<SeleccionBloc>().add(SeleccionarEvent( state.rutaPedido.pedidos[0]));
                                      return _trackingPedido( idRuta, pedidosTracking , estadoRuta, pedidosAsignados );
                                    }

                                    if(estadoRuta == "RUTA"){
                                      print("en ruta");
                                      pedidosAsignados = state.rutaPedido.pedidos.where((element) => element.estado == "CURSO"  ).toList();
                                      pedidosTracking = state.rutaPedido.pedidos;
                                      // VALIDACION SI HAY PEDIDOS EN CURSO
                                      if(pedidosAsignados.length > 0){
                                        print("en curso");
                                        _botonesWidgetBloc.add(EventEnCursoBoton( pedidosAsignados[0]));
                                        return _trackingPedido(idRuta, pedidosTracking , estadoRuta, [] );

                                      }else{
                                        pedidosAsignados = state.rutaPedido.pedidos.where((element) => element.estado == "SITIO"  ).toList();
                                        pedidosTracking = state.rutaPedido.pedidos;
                                        // VALIDACION SI HAY PEDIDOS EN ENTREGA
                                        if(pedidosAsignados.length > 0){
                                          print("en sitio");
                                          _botonesWidgetBloc.add(EventEntregarBoton( pedidosAsignados[0] ));
                                          return _trackingPedido( idRuta, pedidosTracking , estadoRuta, [] );

                                        }else{

                                          print("para iniciar");
                                          pedidosAsignados = state.rutaPedido.pedidos.where((element) => element.estado == "ASIGNADO"  ).toList();
                                          pedidosTracking = state.rutaPedido.pedidos;
                                          _botonesWidgetBloc.add(EventIniciarBoton());
                                          context.read<SeleccionBloc>().add(SeleccionarEvent( pedidosAsignados[0]));
                                          return _trackingPedido( idRuta, pedidosTracking , estadoRuta, pedidosAsignados );
                                        }

                                      }

                                    }

                                  }

                                  if(estadoRuta == "RETORNO"){
                                    print("retorno");
                                    pedidosAsignados = [];
                                    _botonesWidgetBloc.add(EventFinalizarBoton());
                                    return _trackingPedido( idRuta, pedidosAsignados , estadoRuta, [] );
                                  }

                                  //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  "PREPARADO", descripcionTracking: "PRODUCTO PREPARADO", listaTracking: estaDomi));



                                  /*if(pedidosAsignados.length > 0){
                                    context.read<SeleccionBloc>().add(SeleccionarEvent( state.rutaPedido.pedidos[0]));

                                    BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  "PREPARADO", descripcionTracking: "PRODUCTO PREPARADO", listaTracking: estaDomi));

                                    return _trackingPedido( pedidosAsignados , estadoRuta );
                                  }*/

                                }
                                if (state is PedidoLoading ){
                                  return Loading();
                                }

                                return Text(" ");
                              }),


                        ]
                    )
                  ;
                }
                return Center(child: CircularProgressIndicator());
              },
            );

          /*Padding(
                padding: EdgeInsets.all(1.0),
                child: Stack(
                    children: [
                      _isGettingLocation ?
                      Center(
                          child : CircularProgressIndicator()
                      ) :


                      BlocBuilder<PedidoBloc, PedidoState>(
                          builder: (BuildContext context, PedidoState state) {
                            if (state is PedidoError) {
                              final error = state.error;
                              //String message = '${error.message}\nTap to Retry.';
                              return Text("fff"
                              );
                            }
                            if (state is PedidoLoaded) {
                              Pedido pedido = state.pedido;
                              //_obtenerLocationEstado( "Iniciar" , "PEDIDO PREPARADO", "Finalizar");
                              //_obtenerLocationEstado(mens_boton, "", "Finalizar");
                              return _trackingPedido(pedido);
                            }
                            return Loading();
                            //return Text("fdf");
                          }),

                      //contador == 2?
                     /* DraggableScrollableSheet(
                        //initialChildSize: 0.10,
                        minChildSize: 0.07,
                        //maxChildSize: 0.6,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Card(
                              elevation: 12.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18.0),
                                    topRight: Radius.circular(18.0)
                                ),
                              ),
                              margin: const EdgeInsets.all(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: CustomInnerContent(),
                              ),
                            ),
                          );
                        },
                      )*/
                          //:
                         // Text("")
                    ]
                )
            );*/
        }
    );


  }


  _loadPedidoUsuario() async {

    //context.read<PedidoBloc>().add(GetPedidoUser("mojombo"));
    //context.read<PedidoBloc>().add(GetPedidoUser("herbivora"));
    context.read<PedidoBloc>().add(GetPedidoUser());
    print("Pedido Cargado");
  }

  //LatLng(4.8087, -75.6906),



  /*_getCurrentLocation() async {

    final _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(_currentPosition);

    setState(() {
      _locationMessage = "${_currentPosition.latitude}, ${_currentPosition.longitude}";

      _latitude = _currentPosition.latitude;
      _longitude = _currentPosition.longitude;
      _isGettingLocation = false;

      points.add(LatLng(_latitude, _longitude));

    });

  }*/




  /*_obtenerLocationEstado(String estado, String descripcion, String next_estado) async {

    final _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print(_currentPosition);

    setState(() {
      _locationMessage = "${_currentPosition.latitude}, ${_currentPosition.longitude}";
      _latitude = _currentPosition.latitude;
      _longitude = _currentPosition.longitude;
      _isGettingLocation = false;

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm').format(now);

        if(contador > 0){
          _esta_domi.add( EstadoDomiciliario( _latitude, _longitude, descripcion, estado ,  formattedDate ) );
          if(estado== "Finalizar" && next_estado ==  "Finalizar" ){
            mensBoton = "Iniciar";

            //_controller.stop();

          }else{
            mensBoton = next_estado;

            points.add(LatLng(_latitude, _longitude));

            //_controller.forward();

          }
        }
        print("ffffffsss");
        contador++;
    });
  }*/

  /*_getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
         // _currentPosition.latitude,
         // _currentPosition.longitude
          casa.latitude,
        casa.longitude
      );

      Placemark placeMark  = placemarks[0];
      String name = placeMark.name;
      String subLocality = placeMark.subLocality;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

      print(address);

      setState(() {
        _currentAddress = address; // update _address
      });

    } catch (e) {
      print(e);
    }
  }*/




  Widget botones(estado, colorBoton, iconBoton, nextEstado, Pedido pedidoSeleccionado, idRuta ){

    return ElevatedButton(
      //color: color_boton,
      //shape: new RoundedRectangleBorder(
          //borderRadius: BorderRadius.circular(5.0)),

      style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white,
          elevation: 5// foreground
      ),

      onPressed: () {
        if(estado == "INICIAR"){
          //_obtenerLocationEstado( estado , "", next_estado);
          print("Hola iniciar: " + pedidoSeleccionado.numero.toString());

         // BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          /*setState(() {
            mens_boton = next_estado;
          });*/

          DateTime now = DateTime.now();
          String formattedDate = DateFormat('kk:mm').format(now);

          print(now);
          print(formattedDate);
          var ruta = now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString();
          print(ruta);

          DateTime date = new DateTime(now.year, now.month, now.day);



          //BlocProvider.of<LocationBloc>(context).add(LocationStarted());
          //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  estado, descripcionTracking: "INICIAR ENTREGA", listaTracking: estaDomi));

          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("CURSO", pedidoSeleccionado, context ));

          //var accion = MarcarPedido( pedidoSeleccionado );
          //alertConfirmacion( context, accion, "PedidoBloc", "Marcar Orden" );

        }
        if(estado == "EN SITIO"){

          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("SITIO", pedidoSeleccionado, context ));

        }

        if(estado == "ENTREGAR"){

          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("ENTREGADO", pedidoSeleccionado, context ));

        }
        else if(estado == "EN RESTAURANTE"){
          //_obtenerLocationEstado( estado , "", next_estado);
          print("Hola");



          BlocProvider.of<PedidoBloc>(context).add(ActualizarRuta("TERMINADA", idRuta, context ));


          BlocProvider.of<LocationBloc>(context).add(LocationStarted());
          //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  estado, descripcionTracking: "INICIAR ENTREGA", listaTracking: estaDomi));
          _botonesWidgetBloc.add(EventFinalizarBoton());
        }



        else{
          //mensajeNovedad();
        }

        },
        //width: 90,
        //height: 40,
        child: Center(
          child: Row( // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              Text(estado + "  ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900
                ),
              ),
              Icon( iconBoton , size: 25,),
            ],
          ),
        ),

    );

  }


  Widget widgetPedidosEntregar( listaraking, pedidosRutaTracking, estadoRuta, idRuta, pedidosAsignados ) {
    return
      Column(
      children: <Widget>[
            SizedBox(height: 12),
            CustomDraggingHandle(),
            SizedBox(height: 5),
            _Header(idRuta, estadoRuta),
        //ScreenProgress(ticks: 3,),

            //SizedBox(height: 16),
            //CustomExplore(),
            //SizedBox(height: 24),
            widgetOperacionPedidos( listaraking, pedidosRutaTracking, estadoRuta, idRuta, pedidosAsignados),
            //SizedBox(height: 16),
      ],

    );
  }


  Widget widgetOperacionPedidos( listaraking, pedidosRutaTracking, estadoRuta, idRuta, pedidosAsignados ) {
    return
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
          children: [
            BlocBuilder<BotonesBloc, BotonesState>(
                builder: (context, state) {

                  print("estado boton");
                  print(state);
                  if (state is BotonStateIniciar) {

                    String valueBoton = state.value;
                    print("88889");
                    print(state.value);

                    return
                      BlocBuilder<SeleccionBloc, SeleccionState>(
                        builder: (BuildContext context, SeleccionState state) {
                          if (state is Selected) {
                            print("DENTRO DEL SELECTED");
                            print(state.pedido.numero.toString());
                            pedidoSeleccionado = state.pedido;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text("Seleccione la orden a entregar",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    dropdownButtonOrdenes(context, pedidoSeleccionado.name , pedidosAsignados),
                                  ],
                                ),

                                Center(
                                  child: botones(valueBoton, Colors.green, Icons.play_arrow_outlined, "Finalizar", pedidoSeleccionado, 0),

                                )
                                /*Botones(mens_boton, Colors.green, Icons.motorcycle_rounded, "Finalizar"),
                        ( mens_boton == "Finalizar")
                        ? Botones("Novedad", Colors.yellow, Icons.event_note_rounded, "Finalizar")
                            : Text("")*/

                          /* CRONOMETRO CONTADOR
                                Countdown(
                                animation: StepTween(
                                begin: 0, // THIS IS A USER ENTERED NUMBER
                                end: levelClock,
                                ).animate(_controller),
                                ),*/
                              ],
                            );

                          }
                          return Loading();
                        }
                    );


                  }
                  else if (state is BotonStateEnSitio){
                    pedidoSeleccionado = state.pedido;

                    print("2222");
                    return
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Orden: "+ state.pedido.restaurante + '-' + state.pedido.numero.toString() ),
                          botones(state.value, Colors.green, Icons.place_outlined, "Finalizar", pedidoSeleccionado, 0),
                        ],
                      );
                  }
                  // else if (state is BotonStateFinalizar) {
                  else if (state is BotonStateEntrega) {
                    pedidoSeleccionado = state.pedido;
                    print("ENtregaa");
                    return
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Orden: " + state.pedido.restaurante + state.pedido.numero.toString() ),
                              botones(state.value, Colors.green, Icons.volunteer_activism, "Finalizar", pedidoSeleccionado, 0),
                              /*ElevatedButton(
                                //onPressed: () => { getDropDownItem(pedidoSeleccionado) },
                                onPressed: ()  {
                                  print("confirm45454acion");
                                  var accion = ActualizarPedido("ENTREGADO", pedidoSeleccionado, context );
                                  //var accion = EntregarPedido( pedidoSeleccionado );
                                  alertConfirmacion( context, accion, "PedidoBloc", "Entregar pedido" );
                                  },
                                child: Icon(Icons.send_outlined, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(10),
                                  primary: Colors.blue,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scanner(opcion: "entregar")));
                                  /*Navigator.popAndPushNamed(context, EscanearFactura.route, arguments: EscanearFactura(opcion: "entregar",));*/

                                  Navigator.pushNamed(
                                    context,
                                    EscanearFactura.route,
                                    //ExtractArgumentsScreen.routeName,
                                    arguments:  "entregar"
                                    //'Extract Arguments Screen',
                                    //'This message is extracted in the build method.',
                                    ,
                                  );

                                },
                                child: Icon(Icons.qr_code_scanner_sharp, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(10),
                                  primary: Colors.blue,
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      );
                    //return Text(state.value);
                  }
                  else if (state is BotonStateFinalizar ) {
                    print("FIN DE TRACKING");

                    return
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tiempo: 45:22 "),
                          botones(state.value, Colors.green, Icons.place_outlined, "Finalizar", pedidoSeleccionado, idRuta ),
                        ],
                      );

                    /*DateTime  horaIniciar;
                    DateTime  horaFinalizar;
                    String tiempoDomicilio = "";

                    String fin;

                    if(listaraking.length > 0) {
                      EstadoDomiciliario a;
                      for (a in listaraking) {
                        print("aaaaa");
                        print(a.estado);

                        if (a.estado == "INICIAR") {
                          horaIniciar = DateFormat("HH:mm:ss").parse(a.hora+":00");
                         // ini = a.hora;
                         // var newDateTimeObj2 = DateFormat("HH:mm:ss").parse("10/02/2000 15:13:09")
                        }
                        if (a.estado == "FINALIZAR") {
                          horaFinalizar = DateFormat("HH:mm:ss").parse(a.hora+":00");

                          //fin = a.hora;
                        }
                      }
                    }

                    Duration _tiempo = horaFinalizar.difference(horaIniciar);
                    fin = _tiempo.toString();

                    var parts = fin.split('.');
                    tiempoDomicilio = parts[0].trim();
                    print(tiempoDomicilio);

                    */
                  }
                  else {
                    print("ELSE");
                    return  Text("Else fuera");
                  }
                }
                ),
            Row(
              children: [
                Flexible(
                  //child:
                  child: TimelineDelivery( listaraking, pedidosRutaTracking, estadoRuta)
                ),
              ],
            )



            //Text( 'Direccion de desino : $_currentAddress  $latlng'),


          ])

          );
  }




  Widget _trackingPedido( idRuta, pedidosRutaTracking, estadoRuta, pedidosAsignados) {
    return DraggableScrollableSheet(
      initialChildSize: 0.087,
      minChildSize: 0.05,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Card(
            //color: Colors.grey,
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)
              ),
            ),
            //margin: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child:
              widgetPedidosEntregar(estaDomi, pedidosRutaTracking, estadoRuta, idRuta,  pedidosAsignados),
              /*BlocBuilder<TrackingBloc, TrackingState>(
                  builder: (BuildContext context, TrackingState state) {

                    if (state is TrackingLoaded) {
                      print("Entro tracking");
                      print(state.estaDomi.length);
                      print(state.estaDomi[0].descripcion);
                      estaDomi = state.estaDomi;
                      return widgetPedidosEntregar(estaDomi, pedidosRutaTracking, estadoRuta, idRuta,  pedidosAsignados);

                    }
                    return Loading();
                    //return Text("fdf");
                  }),*/

             /* BlocListener<TrackingBloc, TrackingState>(
                listener: (context, state) {
                  print("listener");
                  if (state is TrackingLoaded) {
                    print("Entro tracking");
                    print(state.esta_domi.length);
                    print(state.esta_domi[0].descripcion);
                    _esta_domi = state.esta_domi;
                    return CustomInnerContent(_esta_domi);

                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                },
                child:  CustomInnerContent(_esta_domi),
                //CustomInnerContent(),
              ),*/
            ),


             // CustomInnerContent(),
            ),
          );
      },
    );
  }


  /*void _handleTap(LatLng latlng) {

    setState(() {
      //tappedPoints.add(latlng);
      casa = latlng;
      //_getAddressFromLatLng();
      /*_scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text( 'Direccion de desino : $_currentAddress  $latlng'),
      ));*/
    });
  }*/

}



class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.timer, color: Colors.blue,),
          SizedBox(
            width: 5,
          ),
          Text(
            "$timerText",
            style: TextStyle(
              fontSize: 30,
              //color: Theme.of(context).primaryColor,
              color: Colors.blue,
            ),
          )
        ],
      );


   /* ;*/
  }
}



class CustomDraggingHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
    );
  }
}

/*class CustomExplore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Seguimiento", style: TextStyle(fontSize: 22, color: Colors.black45)),
        SizedBox(width: 8),
        Container(
          height: 24,
          width: 24,
          child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.green),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }
}*/

class _Header extends StatelessWidget {

  int idR;
  String estadoRuta;

  _Header(this.idR, this.estadoRuta);
  @override
  Widget build(BuildContext context) {
    String mensText = "";
    print(estadoRuta);
    print('estadoRuta');
    if(estadoRuta.trim() == "RUTA"){
      mensText = "EN CAMINO";
    }
    if(estadoRuta == "RESTAURANTE"){
      mensText = "EN RESTAURANTE";
    }
    if(estadoRuta == "RETORNO"){
      mensText = "RETORNO";
    }

    return Container(
      decoration: const BoxDecoration(
        //color: Colors.yellow,
        border: Border(
          bottom: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Icon(Icons.reorder),
            Text('RUTA '+ idR.toString() , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,) ),
            Text( "ESTADO: " + mensText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red) ),
            /*ElevatedButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (_) => NovedadDialog( "" ),
                );
                },
              child: Icon(Icons.message, color: Colors.white, size: 15,),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                //primary: Colors.blue, // <-- Button color
                onPrimary: Colors.red, // <-- Splash color
              ),
            )*/


          ],
        ),
        /*child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.shopping_cart_outlined),
            Text('PEDIDOS A ENTREGAR ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,) ),
            Text(
              '#2482011',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,)
              /*style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),*/
            ),

          ],
        ),*/
      ),
    );
  }
}


class ScreenProgress extends StatelessWidget {

  final int ticks;

  ScreenProgress({@required this.ticks});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        tick1(),
        spacer(),
        line(),
        spacer(),
        tick2(),
        spacer(),
        line(),
        spacer(),
        tick3(),
        spacer(),
        line(),
        spacer(),
        tick4(),
      ],
    );


  }

  Widget tick(bool isChecked){
    return isChecked?Icon(Icons.check_circle,color: Colors.blue,):Icon(Icons.radio_button_unchecked, color: Colors.blue,);
  }

  Widget tick1() {
    return this.ticks>0?tick(true):tick(false);
  }
  Widget tick2() {
    return this.ticks>1?tick(true):tick(false);
  }
  Widget tick3() {
    return this.ticks>2?tick(true):tick(false);
  }
  Widget tick4() {
    return this.ticks>3?tick(true):tick(false);
  }

  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line() {
    return Container(
      color: Colors.blue,
      height: 5.0,
      width: 50.0,
    );
  }
}













