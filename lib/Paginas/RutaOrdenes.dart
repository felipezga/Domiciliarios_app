import 'package:domiciliarios_app/Bloc/BotonesTrackingBloc.dart';
import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/SeleccionBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Bloc/UserLocationBloc.dart';
import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/DialogNovedad.dart';
import 'package:domiciliarios_app/widgets/DropdownButtonOrdenes.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/TimeLine.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


class RutaOrdenes extends StatelessWidget{
  static const String route = '/ruta';

  @override
  Widget build(BuildContext context) {
    return /*BlocProvider(
      create: (context) => PedidoBloc(pedidoRepo: PedidoDomiclioRepository()),*/
      MultiBlocProvider(
        providers: [
          BlocProvider<PedidoBloc>(
            create: (BuildContext context) =>  PedidoBloc(pedidoRepo: PedidoDomiclioRepository()),
          ),
          BlocProvider<BotonesBloc>(
              create: (context) {
                return BotonesBloc();
              }),
          BlocProvider<SeleccionBloc>(
              create: (context) {
                return SeleccionBloc();
              })
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
          return new Scaffold(
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.red,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }),
            //automaticallyImplyLeading: false,
            title: Text(
              'RUTA - ORDENES',
              style: TextStyle(
                color: theme.getTheme.hoverColor,
                fontWeight: FontWeight.bold,
                //fontSize: 30,
              ),
            ),
          ),
          drawer: buildDrawer(context, RutaOrdenes.route),
          body: RutaState(),
        );
    })
      );
  }
}

class RutaState extends StatefulWidget{
  RutaState() : super();
  _AppState createState() => _AppState();
}

class _AppState extends State<RutaState> {
//class _AppState extends State<mapaState> with TickerProviderStateMixin {

  BotonesBloc _botonesWidgetBloc;

  String dropdownValue = '-';
  List<Pedido> pedidosAsignados = [];
  List<Pedido> pedidosTracking = [];
  String estadoRuta;
  int idRuta;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //double _latitude;
  //double _longitude;
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

    contador = 0;

    _loadPedidoUsuario();

  }

  @override
  Widget build(BuildContext context) {

    _botonesWidgetBloc = BlocProvider.of<BotonesBloc>(context);

                  return
                    Stack(
                        children: [
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

                                  return
                                    SingleChildScrollView(
                                        padding: EdgeInsets.all(30.0),
                                        child: Column(
                                            children: [
                                              SizedBox(height: 30,),
                                              Image(
                                                image: new AssetImage("images/domiciliario.png"),
                                                width: 200,
                                                height: 200,
                                                color: null,
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                    Text(
                                                        "No tiene rutas por realizar, ni ordenes asignadas ",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w600,
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              )

                                            ],
                                        )
                                    );
                                }
                                if (state is PedidoLoading ){
                                  return Loading();
                                  //return Center(child: CircularProgressIndicator());
                                }

                                return Text(" ");
                              }),
                        ]
                    );
      //  }
   // );

  }


  _loadPedidoUsuario() async {

    //context.read<PedidoBloc>().add(GetPedidoUser("mojombo"));
    //context.read<PedidoBloc>().add(GetPedidoUser("herbivora"));
    context.read<PedidoBloc>().add(GetPedidoUser());
    print("Pedido Cargado");
  }


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
          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("CURSO", pedidoSeleccionado, context ));

          /*DateTime now = DateTime.now();
          String formattedDate = DateFormat('kk:mm').format(now);
          print(now);
          print(formattedDate);
          var ruta = now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString();
          print(ruta);
          DateTime date = new DateTime(now.year, now.month, now.day);
           */
        }
        if(estado == "EN SITIO"){
          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("SITIO", pedidoSeleccionado, context ));

        }

        if(estado == "ENTREGAR"){
          BlocProvider.of<PedidoBloc>(context).add(ActualizarPedido("ENTREGADO", pedidoSeleccionado, context ));

        }
        else if(estado == "EN RESTAURANTE"){
          BlocProvider.of<PedidoBloc>(context).add(ActualizarRuta("TERMINADA", idRuta, context ));

          BlocProvider.of<LocationBloc>(context).add(LocationStarted());
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


  Widget widgetOperacionPedidos( listaraking, pedidosRutaTracking, estadoRuta, idRuta, pedidosAsignados ) {
    return
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
              children: [
                BlocBuilder<BotonesBloc, BotonesState>(
                    builder: (context, state) {
                      print("estado boton");
                      print(state);
                      if (state is BotonStateIniciar) {
                        String valueBoton = state.value;
                        print(state.value);

                        return
                          BlocBuilder<SeleccionBloc, SeleccionState>(
                              builder: (BuildContext context, SeleccionState state) {
                                if (state is Selected) {
                                  print("DENTRO DEL SELECTED");
                                  print(state.pedido.numero.toString());
                                  pedidoSeleccionado = state.pedido;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    ],
                                  );
                                }
                                return Loading();
                              }
                          );
                      }
                      else if (state is BotonStateEnSitio){
                        pedidoSeleccionado = state.pedido;
                        return
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "ORDEN ",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,) ,
                                  ),
                                  Text(
                                    state.pedido.restaurante + '-' + state.pedido.numero.toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,) ,
                                  ),
                                ],
                              ),
                              botones(state.value, Colors.green, Icons.place_outlined, "Finalizar", pedidoSeleccionado, 0),
                            ],
                          );
                      }
                      else if (state is BotonStateEntrega) {
                        pedidoSeleccionado = state.pedido;
                        print("ENtregaa");
                        return
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "ORDEN ",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,) ,
                                      ),
                                      Text(
                                        state.pedido.restaurante + '-' + state.pedido.numero.toString(),
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,) ,
                                      ),

                                    ],
                                  ),
                                  botones(state.value, Colors.green, Icons.volunteer_activism, "Finalizar", pedidoSeleccionado, 0),
                                ],
                              ),
                            ],
                          );
                      }
                      else if (state is BotonStateFinalizar ) {
                        print("FIN DE TRACKING");
                        return
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 30,),
                              //Text("Tiempo: 45:22 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,)),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  botones(state.value, Colors.green, Icons.place_outlined, "Finalizar", pedidoSeleccionado, idRuta ),
                                ],

                              ),
                              SizedBox(height: 30,),

                            ],
                          );
                      }
                      else {
                        print("ELSE");
                        return  Text("Else");
                      }
                    }
                ),
                Divider( height: 15,),
                /*Text(
                    'ESTADO ORDENES',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)
                ),*/
                Row(
                  children: [
                    Flexible(
                      //child:
                        child: TimelineDelivery( listaraking, pedidosRutaTracking, estadoRuta)
                    ),
                  ],
                )
              ]
          )
      );
  }


  Widget _trackingPedido( idRuta, pedidosRutaTracking, estadoRuta, pedidosAsignados) {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //SizedBox(height: 10),
            Header(idRuta, estadoRuta),
            //Divider(),
            //ScreenProgress(ticks: 3,),
            //SizedBox(height: 10),
            widgetOperacionPedidos( estaDomi, pedidosRutaTracking, estadoRuta, idRuta, pedidosAsignados),
            //SizedBox(height: 16),
          ],
        )

        );

  }

}


class Header extends StatelessWidget {

  int idR;
  String estadoRuta;

  Header(this.idR, this.estadoRuta);
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

    return Card(
      elevation: 8,
      color: Colors.yellow[600],
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment : MainAxisAlignment.start,
                crossAxisAlignment :CrossAxisAlignment.center,
              children: [
                Text('RUTA' , style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black) ),
                Text( idR.toString() , style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black) ),
              ],
            ),
            //Icon(Icons.reorder),

            Text( "ESTADO: " + mensText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black) ),
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
      ),
    );
  }
}

