import 'dart:async';

import 'package:domiciliarios_app/Modelo/AsignarOrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/FuncionesServicio.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EscaneoEvent {

}

class EscaneandoEvent extends EscaneoEvent{
  String data;
  String opc;
  EscaneandoEvent(this.data, this.opc);
}


class EscaneoBloc extends Bloc<EscaneoEvent, EscaneoState>{
  EscaneoBloc() : super(EscaneoInicial());

  List<asignarOrden> Ordenes = [];

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

        PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();

        // VALIDACCION PARA OBTENER EL ID PARA ASOCIAR AL USUARIO
        if(event.opc =="entregar"){
          final profile = await APIpedido.fetchPedidoUser("1");
          print(profile);

          List<Pedido> pedidoUsuario = profile.where((i) => i.restaurante == fact[0] &&  i.numero == int.parse(fact[1]) ).toList();

          print("Este es el id");
          print(pedidoUsuario[0].id);
          id = pedidoUsuario[0].id;

        }

        Funciones funciones = Funciones();
        UserLocation ubicaion = UserLocation();

        ubicaion = await funciones.ubicacionLatLong();

        Ordenes.add(asignarOrden(id: id, prefijo: fact[0], numero: int.parse(fact[1]), latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: 1));

        print(Ordenes[0].numero);
        print(Ordenes[0].prefijo);





        Salida respuesta;

        if(event.opc =="entregar"){
          respuesta = await APIpedido.entregarPedido( Ordenes );

        }else{
          respuesta = await APIpedido.asignarPedido( Ordenes);

        }




        if(respuesta.code == 0){
          yield EscaneoCompletado(factura);
        }else{
          yield EscaneoExistente(factura + " " +respuesta.mens );
        }


      } catch (e) {
        yield EscaneoError(error: UnknownException( e ) );

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
  EscaneoCompletado(this.respuesta);
}

class EscaneoError extends EscaneoState{
  final error;
  EscaneoError({this.error});
}

class EscaneoExistente extends EscaneoState{
  String asignacion;
  EscaneoExistente(this.asignacion);
}


