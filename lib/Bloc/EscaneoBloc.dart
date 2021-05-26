import 'dart:async';

import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EscaneoEvent {

}

class EscaneandoEvent extends EscaneoEvent{
  EscaneandoEvent();
}


class EscaneoBloc extends Bloc<EscaneoEvent, EscaneoState>{
  EscaneoBloc() : super(EscaneoInicial());

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
        Timer(Duration(seconds: 5), () {
          print("Yeah, this line is printed after 3 seconds");
        });

        /*Future.delayed(Duration(milliseconds: 100), () async* {
          // Do something

        });*/
        yield EscaneoCompletado("Excelente");


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

