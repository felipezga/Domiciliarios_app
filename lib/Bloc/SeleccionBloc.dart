import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SeleccionEvent {}


class SeleccionarEvent extends SeleccionEvent {
  final Pedido pedido;
  SeleccionarEvent(this.pedido);
}


class SeleccionBloc extends Bloc<SeleccionEvent, SeleccionState> {


  SeleccionBloc() : super(SPedidoInitial());

  @override
  Stream<SeleccionState> mapEventToState(SeleccionEvent event) async* {
    // TODO: implement mapEventToState
    try {

      if (event is SeleccionarEvent){
        print("Pedido selected");
        yield (Selected(event.pedido));
      }
    } on UserNotFoundException {
      //yield (PedidoError('This User was Not Found!'));
    }
  }

}


abstract class SeleccionState {
  const SeleccionState();

}

  class SPedidoInitial extends SeleccionState {
  const SPedidoInitial();
  }


  class Selected extends SeleccionState {
  final Pedido pedido;
  const Selected(this.pedido);
}

