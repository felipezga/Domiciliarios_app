import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reasignacion extends StatelessWidget {

  Reasignacion( this.arguments );

  static const String route = '/reasignacion';

  final String arguments;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("ESCANEAR " + arguments);

    //return ReasignacionScreen(opcion : arguments);

    return BlocProvider(
      create: (context) { return PedidoBloc(pedidoRepo: PedidoDomiclioRepository())..add(GetPedidoUser());
      },
      child:  ReasignacionScreen(),
    );

    throw UnimplementedError();
  }
}

class ReasignacionScreen extends StatefulWidget {

 // ReasignacionScreen({Key key, this.opcion}) : super(key: key);

  //final String opcion;

  @override
  _ReasignacionState createState() => _ReasignacionState();
}

class _ReasignacionState extends State<ReasignacionScreen> {

  bool _isChecked = true;
  String _currText = '';

  String  _chosenValue  ;

    List<Pedido> pedidos = [];

  List<String> text = ["InduceSmile.com", "Flutter.io", "google.com"];

  String opc;

  @override
  void initState() {
    print("Reasignar");

    //context.read<PedidoBloc>().add(GetPedidoUser("1"));

    print("siii");

    super.initState();

    /*opc = widget.opcion;
    print('Este es: ');
    print(opc);
*/
  }


  @override
  Widget build(BuildContext context) {


    List<ListItem> _dropdownItems = [
      ListItem("F07183fdeb8e495940c38be2d750fc720d4d", " 000 IVAN	NARANJO"),
      ListItem("G0529eb74ab18b1744509282efd5bb0f9951", "9692468	JUAN	LOPEZ"),
      ListItem("F502df663e3943d94dc6a85e44db14421790", "80854915	1-ARLEY	SALDAÑA   3203443838"),
      ListItem("H19132474f0977e548b986caf2dbb6a9be15", "4104238	JUAN 	RAMOS")
    ];

    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.purple[200],
          leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.red,),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
          ),
          //automaticallyImplyLeading: false,
          title: Text(
            'REASIGNACION ENTREGA',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, Reasignacion.route),
        body:
        //reasinar()
            /*Expanded(
              child: Center(
                child: Text(_currText,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),*/

           Column(
      children: <Widget>[
        BlocBuilder<PedidoBloc, PedidoState>(
            builder: (context, state) {

              if (state is PedidoLoading ){

                print("ALgo pasa");
                return Loading();
              }
              if (state is PedidoLoaded) {
                print("pasin");

                pedidos = state.pedido;

                return  //Expanded(
                    //child:
                    Container(
                      //color: Colors.grey[400],
                      height: 300.0,
                      child: ListView(
                        children: pedidos.map((ped) => CheckboxListTile(
                          title: Text(ped.restaurante + ped.numero.toString(), style: TextStyle(
                            color: theme.getTheme.hoverColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                          value: ped.checked,
                          onChanged: (val) {

                            print(ped.numero);
                            setState(() {
                              ped.checked = val;

                            });
/*
                      BlocProvider.of<TodosBloc>(context).add(
                        TodoUpdated(
                          todo.copyWith(complete: !todo.complete),
                        ),
                      );*/
                          },
                        ))
                            .toList(),
                      ),
                    );
                //);

              }
              return Expanded(
                child: Center(
                  child: Text("No hay entregas por reasignar",
                      style: TextStyle(
                        color: theme.getTheme.hoverColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              );

            }
        ),
        SizedBox(
          height: 20,
        ),

        DropdownButton<String>(
          //focusColor:Colors.white,
          value: _chosenValue,
          //elevation: 5,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          iconEnabledColor:Colors.black,
          items: _dropdownItems.map((ListItem item) {
            return DropdownMenuItem<String>(
              value: item.value,
              child: Text(item.name,style:TextStyle(
                  //color:Colors.black
              ),),
            );
          }).toList(),
          hint:Text(
            "Por favor seleccione un domiciliario",
            style: TextStyle(
                //color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          onChanged: ( valu) {
            setState(() {
              print(valu);
              _chosenValue = valu;
            });
          },
        ),

        SizedBox(
          height: 20,
        ),

        Row(
            mainAxisAlignment : MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green, // background
                  //onPrimary: Theme.of(context).textTheme.bodyText1.color,
                  elevation: 5// foreground
              ),
              onPressed: (){
                print(pedidos[0].numero);
                print(pedidos[0].checked);
                //Navigator.popAndPushNamed(context, '/escaner');
                BlocProvider.of<PedidoBloc>(context).add(reasignarPedido( pedidos, _chosenValue ));
                //Navigator.pop(context, todo);
              },
              //width: 90,
              //height: 40,
              child: Center(
                child: Row( // Replace with a Row for horizontal icon + text
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Reasignar  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Icon( Icons.reply_all_sharp , size: 23, color: Theme.of(context).backgroundColor,),
                  ],
                ),
              ),

            ),
          ],
        ),




        ]
      ),







      );
    });
  }



}

class ListItem {
  String value;
  String name;

  ListItem(this.value, this.name);
}




