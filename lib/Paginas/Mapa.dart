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
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/NotificacionPushFirebase.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/ErrorText.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:domiciliarios_app/widgets/TimeLine.dart';
//import 'package:restaurantes_tipoventas_app/widgets/drawer.dart';
import 'package:geocoding/geocoding.dart';

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
          BlocProvider<TrackingBloc>(
              create: (context) {
            return TrackingBloc();
          }),
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

          body: mapaState(),
        ),
    );
    /*return new Scaffold(
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

      body: mapaState(),
    );*/
  }
}

class mapaState extends StatefulWidget{
  mapaState() : super();
  _AppState createState() => _AppState();
}

class _AppState extends State<mapaState> {
//class _AppState extends State<mapaState> with TickerProviderStateMixin {

  BotonesBloc _botonesWidgetBloc;
  String _locationMessage = "";
  Future<Position> UserPosition;
  String _currentAddress;

  // Default Drop Down Item.
  String dropdownValue = '-';
  List<Pedido> pedidosAsignados = [];

  // To show Selected Item in Text.
  String holder = '' ;

  List <String> actorsName = [
    '11111111',
    '2222222',
    '3333333',
    '44444444',
    '555555'
  ] ;

  void getDropDownItem(){
print("Vamos tio");
/*
    setState(() {
      holder = dropdownValue ;
    });*/
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _latitude;
  double _longitude;
  bool _isGettingLocation;
  String mens_boton = "Iniciar";
  int contador;

  //int _counter = 0;
  //AnimationController _controller;
  //int levelClock = 180;

  List<EstadoDomiciliario> _esta_domi = [];
  List<LatLng> points = [];

  List<LatLng> tappedPoints = [];
  LatLng casa;

  static const darkLink = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}@2x.png';
  static const lightLink = 'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png';
  //https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png


  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  TextEditingController  descripcionCtrl = new TextEditingController();

  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
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

    final NotificacionServicio = new NotificacionesPush();
    NotificacionServicio.initNotification();

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
                                  return Text("fff"
                                  );
                                }
                                if (state is PedidoLoaded) {
                                  List<Pedido> pedidosAsignados = state.pedido;
                                  dropdownValue = state.pedido[0].name;
                                  //_obtenerLocationEstado( "Iniciar" , "PEDIDO PREPARADO", "Finalizar");
                                  //_obtenerLocationEstado(mens_boton, "", "Finalizar");

                                  context.read<SeleccionBloc>().add(SeleccionarEvent( dropdownValue));

                                  BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  "PREPARADO", descripcionTracking: "PRODUCTO PREPARADO", listaTracking: _esta_domi));
                                  return _trackingPedido( pedidosAsignados );
                                }
                                return Loading();
                                //return Text("fdf");
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
    context.read<PedidoBloc>().add(GetPedidoUser("1"));
    print("Pedido Cargado");
  }

  //LatLng(4.8087, -75.6906),



  _getCurrentLocation() async {

    final _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(_currentPosition);

    setState(() {
      _locationMessage = "${_currentPosition.latitude}, ${_currentPosition.longitude}";

      _latitude = _currentPosition.latitude;
      _longitude = _currentPosition.longitude;
      _isGettingLocation = false;

      points.add(LatLng(_latitude, _longitude));

    });

  }




  _obtenerLocationEstado(String estado, String descripcion, String next_estado) async {

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
            mens_boton = "Iniciar";

            //_controller.stop();

          }else{
            mens_boton = next_estado;

            points.add(LatLng(_latitude, _longitude));

            //_controller.forward();

          }
        }
        print("ffffffsss");
        contador++;
    });
  }

  _getAddressFromLatLng() async {
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
  }


  Widget MensajeNovedad(){
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: descripcionCtrl,
                      ),
                    ),
                    /*Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: myController,
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text("Aceptar"),
                        onPressed: () {
                          save();
                          Navigator.of(context).pop();
                          /**if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }*/
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );

      },
    );
  }

  Widget Botones(estado, color_boton, Icon_boton, next_estado ){

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
          print("Hola");

         // BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          /*setState(() {
            mens_boton = next_estado;
          });*/

            _botonesWidgetBloc.add(EventFinalizarBoton());
          BlocProvider.of<LocationBloc>(context).add(LocationStarted());
          //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  estado, descripcionTracking: "INICIAR ENTREGA", listaTracking: _esta_domi));

        }
        else if(estado == "FINALIZAR"){
          //_obtenerLocationEstado( estado , "", next_estado);
          print("Hola");

          // BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          /*setState(() {
            mens_boton = next_estado;
          });*/


          BlocProvider.of<LocationBloc>(context).add(LocationStarted());
          //BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario( estadoTracking: EstadoDomiciliario( 9.9, 9.6, "Iniciar entrega", "Hoover", ''  ), listaTracking: _esta_domi));
          BlocProvider.of<TrackingBloc>(context).add(AddEstadoDomiciliario(  estadoTracking:  estado, descripcionTracking: "INICIAR ENTREGA", listaTracking: _esta_domi));
          _botonesWidgetBloc.add(EventTiempoRuta());
        }
        else{
          MensajeNovedad();
        }

        },
        //width: 90,
        //height: 40,
        child: Center(
          child: Row( // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon( Icon_boton , size: 30,),
              Text(estado,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900
                ),
              ),
            ],
          ),
        ),

    );

  }


  Widget CustomInnerContent( listaraking, pedidosAsignados ) {
    return
      Column(
      children: <Widget>[
            SizedBox(height: 12),
            CustomDraggingHandle(),
            SizedBox(height: 16),
            _Header(),
        //ScreenProgress(ticks: 3,),

            //SizedBox(height: 16),
            //CustomExplore(),
            //SizedBox(height: 24),
            CustomRecentPhotosText( listaraking, pedidosAsignados),
            //SizedBox(height: 16),
      ],

    );
  }


  Widget CustomRecentPhotosText( listaraking, pedidosAsignados ) {
    return
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
          children: [

              BlocBuilder<BotonesBloc, BotonesState>(
                  builder: (context, state) {
              print("HIT IT");

              if (state is BotonStateIniciar) {
              print("Iniciar");
              return

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    /* CRONOMETRO CONTADOR
                        Countdown(
                        animation: StepTween(
                        begin: 0, // THIS IS A USER ENTERED NUMBER
                        end: levelClock,
                        ).animate(_controller),
                        ),*/
                      Botones(state.Value, Colors.green, Icons.motorcycle_rounded, "Finalizar"),


                    /*Botones(mens_boton, Colors.green, Icons.motorcycle_rounded, "Finalizar"),
                    ( mens_boton == "Finalizar")
                    ? Botones("Novedad", Colors.yellow, Icons.event_note_rounded, "Finalizar")
                        : Text("")*/

                      //: Container()

                      //Padding(
                      // padding: EdgeInsets.only(top: 28.0, bottom: 8.0, left: 8.0),

                    ],
                );

                    /// Show Loading Screen
              //return buildLoadingScreen();
              } else if (state is BotonStateFinalizar) {
              print("finalizar");
              return

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Botones(state.Value, Colors.green, Icons.motorcycle_rounded, "Finalizar"),
                    Botones("Novedad", Colors.yellow, Icons.event_note_rounded, "Finalizar")
                  ],
                );


              /// Show Counter Value
              return Text(state.Value);
              }

              else if (state is FinStateBotones) {
                print("FIN DE TRACKING");
                DateTime  hora_iniciar;
                DateTime  hora_finalizar;
                String tiempo_domicilio = "";

                String ini;
                String fin;

                if(listaraking.length > 0) {
                  EstadoDomiciliario a;
                  for (a in listaraking) {
                    print("aaaaa");
                    print(a.estado);

                    if (a.estado == "INICIAR") {
                      hora_iniciar = DateFormat("HH:mm:ss").parse(a.hora+":00");
                     // ini = a.hora;
                     // var newDateTimeObj2 = DateFormat("HH:mm:ss").parse("10/02/2000 15:13:09")
                    }
                    if (a.estado == "FINALIZAR") {
                      hora_finalizar = DateFormat("HH:mm:ss").parse(a.hora+":00");

                      //fin = a.hora;
                    }
                  }
                }

                Duration _tiempo = hora_finalizar.difference(hora_iniciar);
                fin = _tiempo.toString();

                var parts = fin.split('.');
                tiempo_domicilio = parts[0].trim();
                print(tiempo_domicilio);

                return
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tiempo: "+ tiempo_domicilio)
                    ],
                  );


              }
              else {
              print("ELSE");

              /// Just returning an empty container
              return  Text("Else fuera");;
              }
              }
              ),


          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[


                BlocBuilder<SeleccionBloc, SeleccionState>(
                    builder: (BuildContext context, SeleccionState state) {

                      if (state is Selected) {
                        print("estado seeeee");
                        print(state.pedido);

                        print(pedidosAsignados);
                        //List<Pedido> pedidosAsignados = state.pedido;
                        //dropdownValue = state.pedidoSelected;
                        return DropdownButton<String>(
                          value: state.pedido,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.red,
                          ),
                          onChanged: (String data) {
                            context.read<SeleccionBloc>().add(SeleccionarEvent( data));
                            /*setState(() {
                  dropdownValue = data;
                });*/
                          },
                          //items: actorsName.map<DropdownMenuItem<String>>((String value) {
                          items: pedidosAsignados.map<DropdownMenuItem<String>>((Pedido value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name),
                            );
                          }).toList(),
                        );

                    }
                      /*if(state is PedidoSelected){
                        dropdownValue = state.pedido;
                      }*/
                      return Loading();
                      //return Text("fdf");
                    }),

            RaisedButton(
              child: Text('Confirmar entrega'),
              onPressed: getDropDownItem,
              color: Colors.green,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            ),

          ]),





            //Text("ff"),
            Row(
              children: [
                Flexible(
                  //child:
                  child: _TimelineDelivery( listaraking)
                  /*Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // Con esta propiedad agregamos margen a nuestro Card
                    // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
                    margin: EdgeInsets.all(15),

                    // Con esta propiedad agregamos elevación a nuestro card
                    // La sombra que tiene el Card aumentará
                    elevation: 10,
                    // La propiedad child anida un widget en su interior
                    // Usamos columna para ordenar un ListTile y una fila con botones
                    child: Column(
                      children: <Widget>[
                        // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
                        ListTile(
                          //contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                          title: Text(""),
                          subtitle: Text(
                              ''),
                          leading: Icon(Icons.home),
                        ),

                        // Usamos una fila para ordenar los botones del card
                        /*Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                          FlatButton(onPressed: () => {}, child: Text('Aceptar')),
                                          FlatButton(onPressed: () => {}, child: Text('Cancelar'))
                                          ],
                                          )*/
                      ],
                    ),
                  ),*/

                ),
              ],
            )



            //Text( 'Direccion de desino : $_currentAddress  $latlng'),


          ])

          );
  }




  Widget _trackingPedido( List<Pedido> pedidosAsignados) {
    return DraggableScrollableSheet(
      initialChildSize: 0.13,
      minChildSize: 0.07,
      maxChildSize: 0.65,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Card(
            //color: Colors.blueAccent,
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
              child:
              BlocBuilder<TrackingBloc, TrackingState>(
                  builder: (BuildContext context, TrackingState state) {

                    if (state is TrackingLoaded) {
                      print("Entro tracking");
                      print(state.esta_domi.length);
                      print(state.esta_domi[0].descripcion);
                      _esta_domi = state.esta_domi;
                      return CustomInnerContent(_esta_domi, pedidosAsignados);

                    }
                    return Loading();
                    //return Text("fdf");
                  }),
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


  void _handleTap(LatLng latlng) {

    setState(() {
      //tappedPoints.add(latlng);
      casa = latlng;
      _getAddressFromLatLng();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text( 'Direccion de desino : $_currentAddress  $latlng'),
      ));
    });



  }

  save() {
    if (_formKey.currentState.validate()) {
      print("Nombre ${descripcionCtrl.text}");
      print("Telefono ${myController.text}");
     // print("Correo ${emailCtrl.text}");

      //_obtenerLocationEstado("Novedad",  descripcionCtrl.text, "Finalizar");

      _formKey.currentState.reset();
    }
  }

}



class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
        border: Border(
          bottom: BorderSide(
            color: Colors.red,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.shopping_cart_outlined),
            Text('NUMERO PEDIDO ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,) ),
            Text(
              '#2482011',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,)
              /*style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),*/
            ),

          ],
        ),
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



class _TimelineDelivery extends StatelessWidget {
  List<EstadoDomiciliario> _esta_domi = [];
  _TimelineDelivery( this._esta_domi );


  @override
  Widget build(BuildContext context) {

    print("tiemlinee");
    print(_esta_domi.length);
    EstadoDomiciliario a;
    bool band_preparado = false;
    Color Color_preparado = Color(0xFFDADADA);
    String hora_preparado ="";

    bool band_iniciar = false;
    Color Color_iniciar = Color(0xFFDADADA);
    String hora_iniciar ="";

    bool band_finalizar = false;
    Color Color_finalizar = Color(0xFFDADADA);
    String hora_finalizar ="";


    if(_esta_domi.length > 0){
      for(  a in _esta_domi){
        print("aaaaa");
        print(a.estado);
        if (a.estado == "PREPARADO"){
          band_preparado = true;
          hora_preparado = a.hora;
          Color_preparado =  band_preparado == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }
        if (a.estado == "INICIAR"){
          band_iniciar = true;
          hora_iniciar = a.hora;
          Color_iniciar =  band_iniciar == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }
        if (a.estado == "FINALIZAR"){
          band_finalizar = true;
          hora_finalizar = a.hora;
          Color_finalizar =  band_finalizar == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }

      }

      return Container(
        //height: 45,
        //width: 30,
        //decoration: BoxDecoration(color: Colors.red,),
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: band_preparado == true? Icons.check : Icons.lock_outline_rounded , fontSize: 15 ),
                color: Color_preparado,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                asset: 'images/preparado.png',
                title: 'PRODUCTO PREPARADO',
                message: hora_preparado,
                disabled: !band_preparado,
              ),
              beforeLineStyle:  LineStyle(
                color: Color_preparado,
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: band_iniciar == true? Icons.check : Icons.lock_outline_rounded , fontSize: 16 ),
                color: Color_iniciar,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                disabled: !band_iniciar,
                asset: 'images/domiciliario.png',
                title: 'INICIAR ENTREGA',
                message: hora_iniciar,
              ),
              beforeLineStyle:  LineStyle(
                color: Color_iniciar,
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: band_finalizar == true? Icons.check : Icons.lock_outline_rounded , fontSize: 15 ),
                color: Color_finalizar,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                disabled: !band_finalizar,
                asset: 'images/entregado.png',
                title: 'PEDIDO ENTREGADO',
                message: hora_finalizar,
              ),
              beforeLineStyle:  LineStyle(
                color: Color_finalizar,
              ),
              //afterLineStyle:  LineStyle(
              //  color: Color_finalizar,
              //),
            ),

          ],
        ),
      );


    }else{
      return Container(
        //height: 45,
        //width: 30,
        //decoration: BoxDecoration(color: Colors.red,),
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFFDADADA),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                asset: 'images/frisby.png',
                title: 'PEDIDO PROCESADO',
                message: '',
                disabled: true,
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF27AA69),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/domiciliario.png',
                title: 'INICIAR ENTREGA ',
                message: '',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF2B619C),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/entregado.png',
                title: 'PEDIDO ENTREGADO',
                message: 'Disfruta tu pedido',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFFDADADA),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/frisby.png',
                title: 'Ready to Pickup',
                message: 'Your order is.',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
          ],
        ),
      );
    }



  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: disabled ?  const Color(0xFFBABABA)
                      :  Theme.of(context).textTheme.bodyText1.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                /*style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),*/
              ),
              const SizedBox(height: 6),
              Row(children: [
                !disabled?  Icon( Icons.timer_outlined) : Text(""),
                Text(
                  message,
                  style: TextStyle(
                    color: disabled ?  const Color(0xFFBABABA)
                        :  Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  /*style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),*/
                ),
              ],)

            ],
          ),
        ],
      ),
    );
  }
}










