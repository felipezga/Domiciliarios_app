import 'dart:async';

import 'package:domiciliarios_app/Modelo/AsignarOrdenModel.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EscaneoEvent {

}

class EscaneandoEvent extends EscaneoEvent{
  String data;
  EscaneandoEvent(this.data);
}


class EscaneoBloc extends Bloc<EscaneoEvent, EscaneoState>{
  EscaneoBloc() : super(EscaneoInicial());

  List<asignarOrden> Ordenes = [];

  @override
  Stream<EscaneoState> mapEventToState(EscaneoEvent event) async* {
    // TODO: implement mapEventToState
    if (event is EscaneandoEvent) {

      print("esta escanenado");
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

        print("ggggg");
        var parts = event.data.split('/');
        String factura = parts.last.trim();
        var fact = factura.split('-');

        PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();

        Ordenes.add(asignarOrden(id: 2, prefijo: fact[0], numero: int.parse(fact[1]), usuaId: 1));

        print(Ordenes[0].numero);
        print(Ordenes[0].prefijo);

        final bool respuesta = await APIpedido.asignarPedido( Ordenes);

        yield EscaneoCompletado(event.data);


      } catch (e) {
        yield EscaneoError(error: UnknownException('Unknown Error') );

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

