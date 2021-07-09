import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*class Confirmacion extends StatelessWidget {
  final  accionBloc;
  final String pregunta;
  final context;

  Confirmacion( this.context, this.accionBloc, this.pregunta);
*/
  //@override
 // Widget build(BuildContext context) {
   // print("alerta entro");

    //Confirmacion(context, pedidoSeleccionado){

    void alertConfirmacion(cont, accionBloc,  bloc, pregunta) {

      showDialog(
          context: cont ,
          builder: (context) {
            return AlertDialog(
              title: Text(pregunta),
              content: Text("Esta seguro de confirmar esta operacion?"),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
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
                      onPressed: ()  {

                        if(bloc == "PedidoBloc"){
                          BlocProvider.of<PedidoBloc>(cont).add(accionBloc);
                        }
                        if(bloc == "entregarbloc"){
                          BlocProvider.of<PedidoBloc>(cont).add(accionBloc);
                        }

                        //Provider.of<PedidoBloc>(context, listen: false)
                        // context.read<PedidoBloc>().add(accionBloc)

                        Navigator.of(context).pop();
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


//}



