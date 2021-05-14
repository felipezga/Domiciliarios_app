import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
abstract class PedidoEvent {}

class GetPedidoUser extends PedidoEvent {
  final String userName;
  GetPedidoUser(this.userName);
}


 class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {

   final PedidoDomiclioRepository pedidoRepo;
   PedidoBloc({this.pedidoRepo}) : super(PedidoInitial());

   @override
   Stream<PedidoState> mapEventToState(PedidoEvent event) async* {
     // TODO: implement mapEventToState
     try {
       if (event is GetPedidoUser) {
         print("entroooo");
         yield (PedidoLoading());
         final profile = await pedidoRepo.fetchPedidoUser(event.userName);
         print(profile);
         yield (PedidoLoaded(profile));
       }
     } on UserNotFoundException {
       yield (PedidoError('This User was Not Found!'));
     }
   }

 }


abstract class PedidoState {
  const PedidoState();
}

class PedidoInitial extends PedidoState {
  const PedidoInitial();
}

class PedidoLoading extends PedidoState {
  const PedidoLoading();
}

class PedidoLoaded extends PedidoState {
  final Pedido pedido;
  const PedidoLoaded(this.pedido);
}

class PedidoError extends PedidoState {
  final String error;
  const PedidoError(this.error);
}
