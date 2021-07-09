import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/FuncionesServicio.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/ShowSnackBar.dart';
import 'package:flutter/material.dart';


/// Events
abstract class BotonesEvent {}

class EventIniciarBoton extends BotonesEvent {}

class EventEntregarBoton extends BotonesEvent {
  Pedido pedido;
  EventEntregarBoton(this.pedido);
}

class EventEnCursoBoton extends BotonesEvent{
  Pedido pedido;
  EventEnCursoBoton(this.pedido);
}

class EventFinalizarBoton extends BotonesEvent {}

class EventNovedadBoton extends BotonesEvent {}

class EventTiempoRuta extends BotonesEvent{}

/// States
class BotonesState {}

class BotonStateLoading extends BotonesState {}

class BotonStateEnSitio extends BotonesState {
  final Pedido pedido;
  final String value;
  BotonStateEnSitio(this.value, this.pedido);
}

class BotonStateEntrega extends BotonesState {
  final Pedido pedido;
  final String value;
  BotonStateEntrega(this.value, this.pedido);
}

class BotonStateIniciar extends BotonesState {
  final String value;
  BotonStateIniciar(this.value);
}

class BotonStateFinalizar extends BotonesState {
  final String value;
  BotonStateFinalizar(this.value);
}

class FinStateBotones extends BotonesState {
  FinStateBotones();
}

class BotonStateNovedad extends BotonesState {
  final String value;
  BotonStateNovedad(this.value);
}

/*
class ShowCounterValue extends CounterScreenState {
  @override
  List<Object> get props => [counterValue];

  final int counterValue;

  ShowCounterValue(this.counterValue);
}*/

/// BLoC
class BotonesBloc extends Bloc<BotonesEvent,BotonesState> {
  int counterValue = 0;

  BotonesBloc() : super(BotonStateIniciar("INICIAR"));

  List<Orden> ordenes = [];

  @override
  Stream<BotonesState> mapEventToState(BotonesEvent event) async* {
    if (event is EventIniciarBoton) {
      yield BotonStateIniciar("INICIAR");
    }

    if (event is EventEntregarBoton) {
      yield BotonStateEntrega("ENTREGAR", event.pedido);
    }

    if (event is EventEnCursoBoton) {
      yield BotonStateEnSitio("EN SITIO", event.pedido);
    }



    if (event is EventFinalizarBoton) {
      yield BotonStateFinalizar("FINALIZAR");
    }

    if (event is EventTiempoRuta) {
      yield FinStateBotones();
    }

    if (event is BotonStateNovedad) {
      /// Showing Loading Screen
      yield BotonStateLoading();

      /// Created a repository called CounterRepo
      /// which is responsible for getting data
      //counterValue = await CounterRepo().getRandomValue();

      /// Showing the random number
      yield BotonStateNovedad("Novedad");
    }
  }
}