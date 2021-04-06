import 'dart:async';
//import 'dart:ffi';

import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Servicios/NotificacionPushFirebase.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
//import 'package:restaurantes_tipoventas_app/widgets/drawer.dart';
import 'package:geocoding/geocoding.dart';

class Mapa extends StatelessWidget{
  static const String route = '/mapa';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: AppBar(title: new Text("MAPA"),),
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: buildDrawer(context, Mapa.route),
      body: mapaState(),
    );
  }
}

class mapaState extends StatefulWidget{
  mapaState() : super();
  _AppState createState() => _AppState();
}


class _AppState extends State<mapaState> with TickerProviderStateMixin {

  String _locationMessage = "";
  Position _currentPosition;
  String _currentAddress;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _latitude;
  double _longitude;
  bool _isGettingLocation;
  String mens_boton = "Iniciar";
  int contador;

  int _counter = 0;
  AnimationController _controller;
  int levelClock = 180;

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
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //LatLng _new = LatLng(33.738045, 73.084488);
    //points.add(_new);

    _isGettingLocation = true;
    _obtenerLocationEstado(mens_boton, "", "Finalizar");
    contador = 0;

    /*/_timer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        _getCurrentLocation();
      });
    });*/



    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    final NotificacionServicio = new NotificacionesPush();
    NotificacionServicio.initNotification();

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

            _controller.stop();

          }else{
            mens_boton = next_estado;

            points.add(LatLng(_latitude, _longitude));

            _controller.forward();

          }
        }
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
                      child: RaisedButton(
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

    return RaisedButton(
      color: color_boton,
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
      onPressed: () {
        if(estado != "Novedad"){
          _obtenerLocationEstado( estado , "", next_estado);
        }else{
          MensajeNovedad();
        }

        },
      child: SizedBox(
        width: 90,
        height: 40,
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
      ),
    );

  }


  Widget CustomInnerContent() {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        CustomDraggingHandle(),
        SizedBox(height: 16),
        CustomExplore(),
        SizedBox(height: 24),
        CustomRecentPhotosText(),
        SizedBox(height: 16),
      ],
    );
  }


  Widget CustomRecentPhotosText() {
    return
        Padding(
          padding: EdgeInsets.only(top: 0.0, bottom: 2.0),
          child: Column(
          children: [
          Row(
            children: [
            Column(
              children:[
              Countdown(
              animation: StepTween(
              begin: 0, // THIS IS A USER ENTERED NUMBER
              end: levelClock,
              ).animate(_controller),
              ),
              Botones(mens_boton, Colors.green, Icons.motorcycle_rounded, "Finalizar"),
              ( mens_boton == "Finalizar")
              ? Botones("Novedad", Colors.yellow, Icons.event_note_rounded, "Finalizar")
                  : Text("")   //: Container()
              ]
            ),
            //Padding(
            // padding: EdgeInsets.only(top: 28.0, bottom: 8.0, left: 8.0),
            Flexible(
              //child:
              child:
              _esta_domi.length > 0
              ?
              Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(15),
              elevation: 5,
              child: Column(
              children: <Widget>[
              ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _esta_domi.length,
              itemBuilder: (BuildContext context, int index) {
              print(_esta_domi[index].estado);
              var lat = _esta_domi[index].lat;
              var long = _esta_domi[index].long;
              return

              ListTile(
              //contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text(_esta_domi[index].estado, style: TextStyle(
              fontSize: 18,
              //color: Theme.of(context).primaryColor,
              color: Colors.blue,
              fontWeight: FontWeight.bold

              )),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ Icon(Icons.watch_later_outlined),Text( _esta_domi[index].hora)],)
              ,]),

              subtitle: Text( 'Lat:$lat  Long:$long'),
              //leading: Icon(Icons.motorcycle_rounded),
              );
              })
              ],
              ),
              )
                  :
              Card(
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
              ),





            ),
            ],
          ),



            //Text( 'Direccion de desino : $_currentAddress  $latlng'),


          ])

          );
  }


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          var isDarkMode = theme.getThemeState;
          return
            Padding(
                padding: EdgeInsets.all(1.0),
                child: Stack(
                    children: [
                      _isGettingLocation ?
                      Center(
                          child : CircularProgressIndicator()
                      ) :
                      Scaffold(
                          key: _scaffoldKey,
                          body: FlutterMap(
                            options: MapOptions(
                                center: LatLng(_latitude, _longitude),
                                zoom: 16.0,
                                maxZoom: 18.0,
                                minZoom: 2.0,
                                onTap: _handleTap
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
                                    point: LatLng(_latitude, _longitude),
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
                      DraggableScrollableSheet(
                        initialChildSize: 0.10,
                        minChildSize: 0.05,
                        maxChildSize: 0.6,
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
                              margin: const EdgeInsets.all(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: CustomInnerContent(),
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                )
            );
        }
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

      _obtenerLocationEstado("Novedad",  descripcionCtrl.text, "Finalizar");

      _formKey.currentState.reset();
    }
  }

}


class EstadoDomiciliario{
  double lat;
  double long;
  String descripcion;
  String estado;
  String hora;

  EstadoDomiciliario(lat, long, descripcion, estado, hora){
    this.lat = lat;
    this.long = long;
    this.descripcion = descripcion;
    this.estado = estado;
    this.hora = hora;
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
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class CustomExplore extends StatelessWidget {
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
}










