import 'package:domiciliarios_app/Bloc/SeleccionBloc.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



Widget dropdownButtonOrdenes(cont, valueDrop, pedidosAsignados) {

  return DropdownButton<String>(
    value: valueDrop,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(color: Colors.red, fontSize: 18),
    /*underline: Container(
                                  height: 2,
                                  color: Colors.red,
                                ),*/
    onChanged: (String data) {

      List<Pedido> cambioPedido = pedidosAsignados.where((i) => i.name == data ).toList();

      print("cambio dropdown");
      print(cambioPedido[0].id);
      print(cambioPedido[0].name);
       BlocProvider.of<SeleccionBloc>(cont).add(SeleccionarEvent(  cambioPedido[0] ));
      /*setState(() {
                  dropdownValue = data;
                });*/
    },
    items: pedidosAsignados.map<DropdownMenuItem<String>>((Pedido value) {
      return DropdownMenuItem<String>(
        value: value.name,
        child: Text(value.name),
      );
    }).toList(),
  );

}


//}



