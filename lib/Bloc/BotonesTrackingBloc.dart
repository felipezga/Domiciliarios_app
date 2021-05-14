import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


/// Events
abstract class BotonesEvent {}

class EventIniciarBoton extends BotonesEvent {}

class EventFinalizarBoton extends BotonesEvent {}

class EventNovedadBoton extends BotonesEvent {}

class EventTiempoRuta extends BotonesEvent{}

/// States
class BotonesState {}

class BotonStateLoading extends BotonesState {}


class BotonStateIniciar extends BotonesState {
  final String Value;
  BotonStateIniciar(this.Value);
}

class BotonStateFinalizar extends BotonesState {
  final String Value;
  BotonStateFinalizar(this.Value);
}

class FinStateBotones extends BotonesState {
  FinStateBotones();
}

class BotonStateNovedad extends BotonesState {
  final String Value;
  BotonStateNovedad(this.Value);
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


  @override
  Stream<BotonesState> mapEventToState(BotonesEvent event) async* {
    if (event is EventIniciarBoton) {
      yield BotonStateIniciar("INICIAR");
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