import 'package:domiciliarios_app/Modelo/AsignarOrdenModel.dart';
import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/FuncionesServicio.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class PedidoEvent {}

class GetPedidoUser extends PedidoEvent {

  GetPedidoUser();
}

class entregarPedido extends PedidoEvent {
  final Pedido pedido;
  entregarPedido(this.pedido);
}

class reasignarPedido extends PedidoEvent {
  final List<Pedido> pedidos;
  final String UserId;
  reasignarPedido(this.pedidos, this.UserId);
}




 class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {

   final PedidoDomiclioRepository pedidoRepo;
   PedidoBloc({this.pedidoRepo}) : super(PedidoInitial());

   List<asignarOrden> Ordenes = [];

   @override
   Stream<PedidoState> mapEventToState(PedidoEvent event) async* {
     // TODO: implement mapEventToState
     try {
       if (event is GetPedidoUser) {
         print("Obtener Pedidos");
         yield (PedidoLoading());

         /*Ordenes.clear();
         asignarOrden ao = new asignarOrden(id: 0, prefijo: "F01", numero: 8888, latitud: 3.1, longitud: 4.7, usuaId: 1);
          print(ao);
          print("ao");
         Ordenes.add(ao);


         PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();
         print("eres");
         print(Ordenes[0]);
         final int respuesta = await APIpedido.asignarPedido( Ordenes );
         print(respuesta);
         print("Salida");
         */

         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         final profile = await pedidoRepo.fetchPedidoUser(userId);
         print(profile);
         yield (PedidoLoaded(profile));
       }

       if (event is entregarPedido) {
         print("Entregar Pedido");
         yield (PedidoLoading());

         Ordenes.clear();

         Funciones funciones = Funciones();
         UserLocation ubicaion = UserLocation();

         ubicaion = await funciones.ubicacionLatLong();

         asignarOrden ao = new asignarOrden(id: event.pedido.id, prefijo: event.pedido.restaurante, numero: event.pedido.numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: event.pedido.usuario);
         print(ao);
         print("ao");
         Ordenes.add(ao);


         PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();
         print("eres");
         print(Ordenes[0]);
         final Salida respuesta = await APIpedido.entregarPedido( Ordenes );
         print(respuesta);
         print("Salida");
         final profile = await pedidoRepo.fetchPedidoUser(event.pedido.usuario.toString());
         print(profile);
         yield (PedidoLoaded(profile));
       }

       if (event is reasignarPedido) {
         print("Reasignar Pedido");
         yield (PedidoLoading());

         Ordenes.clear();
         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         Funciones funciones = Funciones();
         UserLocation ubicaion = UserLocation();

         ubicaion = await funciones.ubicacionLatLong();


         print("BLOC");
         print(event.pedidos[0].numero);

         print(event.pedidos[0].name);

          int cant_pedidos = event.pedidos.length;


         //var item in list
         for (var i = 0; i < cant_pedidos; i++) {
           if (event.pedidos[i].checked == true){

             asignarOrden ao = new asignarOrden(id: event.pedidos[i].id, prefijo: event.pedidos[i].restaurante, numero: event.pedidos[i].numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: event.UserId);
             print(ao);
             print("ao");
             Ordenes.add(ao);
           }
         }


         PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();

         final Salida respuesta = await APIpedido.reasignarPedido( Ordenes );
         print(respuesta);
         print("Reasignacion ");
         final profile = await pedidoRepo.fetchPedidoUser(userId);
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
  final List<Pedido> pedido;
  const PedidoLoaded(this.pedido);
}

class PedidoError extends PedidoState {
  final String error;
  const PedidoError(this.error);
}
