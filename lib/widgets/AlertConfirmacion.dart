import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:flutter/material.dart';
import '../Paginas/Mapa.dart';
import 'package:provider/provider.dart';

class Confirmacion extends StatelessWidget {
  final pedidoSeleccionado;

  Confirmacion(this.pedidoSeleccionado);

  @override
  Widget build(BuildContext context) {
    print("alert");

    //Confirmacion(context, pedidoSeleccionado){

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Entregar producto'),
              content: Text("Estas seguro de aceptar esta accion?"),
              actions: <Widget>[

                /*ElevatedButton.icon(
                  label: Text(" Cancelar"),
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () => { Navigator.pop(context)},
                  style: ElevatedButton.styleFrom(
                    //shape: CircleBorder(),
                    primary: Colors.red,
                  ),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        //Navigator.pop(context)
                        Navigator.of(context).pop(),
                        },
                      child: Icon(Icons.cancel_outlined, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                        primary: Colors.red, // <-- Button color
                        onPrimary: Colors.black, // <-- Splash color
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () => {
                      context.read<PedidoBloc>().add(entregarPedido( pedidoSeleccionado))
                        //getDropDownItem(context, pedidoSeleccionado)
                      },
                      child: Icon(Icons.check_circle_outline_outlined, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                        primary: Colors.green, // <-- Button color
                        onPrimary: Colors.black, // <-- Splash color
                      ),
                    ),
                  ],
                )



              ],
            );
          }
      );
  }


void getDropDownItem(context, pedido){

/*
    setState(() {
      holder = dropdownValue ;
    });*/
}
}



