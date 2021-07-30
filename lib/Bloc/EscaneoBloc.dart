import 'dart:async';

import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/RutaModel.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/FuncionesServicio.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:domiciliarios_app/widgets/ShowSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EscaneoEvent {

}

class EscaneandoEvent extends EscaneoEvent{
  String data;
  String opc;
  List<Orden> ordenesEscan;
  EscaneandoEvent(this.data, this.opc, this.ordenesEscan);
}

class AsignarPedido extends EscaneoEvent {
  final List<Orden> ordenes;
  final BuildContext c;
  AsignarPedido(this.ordenes, this.c);
}


class EscaneoBloc extends Bloc<EscaneoEvent, EscaneoState>{
  EscaneoBloc() : super(EscaneoInicial());

  //List<Orden> ordenes = [];

  @override
  Stream<EscaneoState> mapEventToState(EscaneoEvent event) async* {
    // TODO: implement mapEventToState
    if (event is EscaneandoEvent) {

      //switch (event is AddEstadoDomiciliario) {
      //switch (TrackingEvent) {
      //case AddEstadoDomiciliario:
      yield Escaneando();
      try {
        // Se hace el post
        /*Timer(Duration(seconds: 5), () {
          print("Yeah, this line is printed after 3 seconds");
        });*/

        /*Future.delayed(Duration(milliseconds: 100), () async* {
          // Do something

        });*/

        print("Escanenado Bloc");
        var parts = event.data.split('/');
        String factura = parts.last.trim();
        var fact = factura.split('-');

        var id = 0;
        var estadoOrden = "ASIGNAR";

        PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString("userId");

        // VALIDACCION PARA OBTENER EL ID PARA ASOCIAR AL USUARIO
        if(event.opc =="entregar"){
          final rutaPed = await apiPedido.fetchPedidoUser( userId );
          print(rutaPed);

          List<Pedido> pedidoUsuario = rutaPed.pedidos.where((i) => i.restaurante == fact[0] &&  i.numero == int.parse(fact[1]) ).toList();

          print("Este es el id");
          print(pedidoUsuario[0].id);
          id = pedidoUsuario[0].id;
          estadoOrden = "ENTREGAR";
        }

        /*Funciones funciones = Funciones();
        UserLocation ubicaion = UserLocation();
        ubicaion = await funciones.ubicacionLatLong();
        Orden nuevaOrden = Orden(id: id, estado: estadoOrden, prefijo: fact[0], numero: int.parse(fact[1]), latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: userId);
        */

        Orden nuevaOrden = Orden(id: id, estado: estadoOrden, prefijo: fact[0], numero: int.parse(fact[1]), latitud: 0, longitud: 0, usuaId: userId);

        int existe = event.ordenesEscan.indexWhere((element) => element.numero == nuevaOrden.numero);

        print("exite");

        if( existe == -1 ){
          event.ordenesEscan.add( nuevaOrden );
          yield EscaneoCompletado(factura, event.ordenesEscan);

        }else{
          yield EscaneoExistente( factura +  "  YA ESTÁ ASIGNADO " , event.ordenesEscan );
        }

        /*
        Salida respuesta;

        if(event.opc =="entregar"){
          respuesta = await apiPedido.entregarPedido( ordenes );

        }else{
          respuesta = await apiPedido.asignarPedido( ordenes);

        }

        if(respuesta.code == 1){
          yield EscaneoCompletado(factura);
        }else{
          yield EscaneoExistente( respuesta.mens + " "+ factura );
        }

        */
      } catch (e) {
        print(e);
        yield ErrorAgregar(error: "PROBLEMAS AL LEER EL CODIGO", listOrdenes: event.ordenesEscan );

      }
    }


    if (event is AsignarPedido) {
      print("Asig Pedido");
      yield (Escaneando());

      if( event.ordenes.length == 0){
        showSnackBarMessage( "No hay pedidos seleccionados " ,  Colors.blue, Icons.warning_amber_outlined, event.c);
      }else{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString("userId");

        PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();

        Funciones funciones = Funciones();
        UserLocation ubicaion = UserLocation();
        ubicaion = await funciones.ubicacionLatLong();

        for(var i = 0 ; i < event.ordenes.length; i++   ){
          event.ordenes[i].latitud = ubicaion.latitude;
          event.ordenes[i].longitud = ubicaion.longitude;
        }

        Ruta ruta =  Ruta( usuaId: userId, ordenes: event.ordenes);

        final Salida respuesta = await apiPedido.asignarPedido( ruta );
        print(respuesta.code);
        print(respuesta.mens);

        String mens = "";
        Color col;
        IconData icono;
        if(respuesta.code == 1){
          mens = "Asignación exitosa!";
          col = Colors.green;
          icono = Icons.check_circle_outline;

          showSnackBarMessage( mens ,  col, icono, event.c);
          //Navigator.popAndPushNamed(event.c, '/mapa');

          yield (EscaneoAsignado(mens: "OK"));

        }else{
          mens = respuesta.mens;
          col = Colors.red;
          icono = Icons.cancel_outlined;

          showSnackBarMessage( mens ,  col, icono, event.c);
          //Navigator.popAndPushNamed(event.c, '/mapa');

          yield EscaneoError( error: mens  );
        }

    }
  }

}

}

abstract class EscaneoState{

}

class EscaneoInicial extends EscaneoState{}

class Escaneando extends EscaneoState {}

class EscaneoCompletado extends EscaneoState{
  String respuesta="";
  List<Orden> listOrdenes;
  EscaneoCompletado(this.respuesta, this.listOrdenes);
}

class EscaneoError extends EscaneoState{
  final error;
  EscaneoError({this.error});
}

class ErrorAgregar extends EscaneoState{
  String error;
  List<Orden> listOrdenes;
  ErrorAgregar({this.error, this.listOrdenes});
}

class EscaneoAsignado extends EscaneoState{
  final mens;
  EscaneoAsignado({this.mens});
  }


class EscaneoExistente extends EscaneoState{
  String asignacion;
  List<Orden> listOrdenes;
  EscaneoExistente(this.asignacion, this.listOrdenes);
}


