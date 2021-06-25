import 'dart:async';
import 'package:bloc/bloc.dart';


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