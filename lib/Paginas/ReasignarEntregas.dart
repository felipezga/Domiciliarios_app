import 'package:domiciliarios_app/Bloc/PedidoBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/AlertConfirmacion.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/ShowSnackBar.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reasignacion extends StatelessWidget {

  //Reasignacion( this.arguments );

  static const String route = '/reasignacion';

  //final String arguments;

  @override
  Widget build(BuildContext context) {
    //return ReasignacionScreen(opcion : arguments);

    return BlocProvider(
      create: (context) { return PedidoBloc(pedidoRepo: PedidoDomiclioRepository())..add(GetPedidoUser());
      },
      child:  ReasignacionScreen(),
    );

  }
}

class ReasignacionScreen extends StatefulWidget {

 // ReasignacionScreen({Key key, this.opcion}) : super(key: key);

  //final String opcion;

  @override
  _ReasignacionState createState() => _ReasignacionState();
}

class _ReasignacionState extends State<ReasignacionScreen> {
  String  _chosenValue;
  List<Pedido> pedidos = [];
  String opc;

  @override
  void initState() {
    print("Reasignar");
    //context.read<PedidoBloc>().add(GetPedidoUser("1"));

    super.initState();

    /*opc = widget.opcion;
    print('Este es: ');
    print(opc);*/
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
            'REASIGNAR PEDIDO',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: buildDrawer(context, Reasignacion.route),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _chosenValue,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      iconEnabledColor:Colors.black,
                      items: _dropdownItems.map((ListItem item) {
                        return DropdownMenuItem<String>(
                          value: item.value,
                          child: Text(
                            item.name,
                            style:TextStyle(
                              //color:Colors.black
                            ),
                          ),
                        );
                      }).toList(),
                      hint:Text(
                        "Seleccione un domiciliario",
                        style: TextStyle(
                            color: theme.getTheme.hoverColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      onChanged: ( valu ) {
                        setState(() {
                          print(valu);
                          _chosenValue = valu;
                        });
                        },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "PEDIDOS / ENTREGAS",
                      style: TextStyle(
                        //color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 220,
                      child: BlocBuilder<PedidoBloc, PedidoState>(
                          builder: (context, state) {
                            if (state is PedidoLoading ){
                              print("Loading");
                              return Loading();
                            }
                            if (state is PedidoLoaded) {
                              print("Hay pedidos");
                              pedidos = state.rutaPedido.pedidos;
                              if(pedidos.length > 0 ){
                                return  ListView(
                                  shrinkWrap: true,
                                  children: pedidos.map((ped) => Card(
                                      //color:  Colors.yellow[600],
                                      elevation: 5,
                                      margin: new EdgeInsets.only( left: 10.0, right: 10.0, top: 8),
                                      child: new Container(
                                        //padding: new EdgeInsets.all(5.0),
                                        child: CheckboxListTile(
                                          value: ped.checked,
                                          title: Text(
                                              ped.restaurante + ped.numero.toString(),
                                              style: TextStyle(
                                                color: theme.getTheme.hoverColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              )
                                          ),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (val) {
                                            print(ped.numero);
                                            setState(() {
                                              ped.checked = val;
                                            });
                                            },
                                        ),
                                      )
                                  )
                                  ).toList(),
                                );
                              }
                              else{
                                return Center(
                                  child: Text(
                                      "No hay entregas por reasignar",
                                      style: TextStyle(
                                        color: theme.getTheme.hoverColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),
                                );
                              }
                            }
                            return  Text(" Inconsistencia");
                          }
                          ),
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
                              // onPrimary: Theme.of(context).textTheme.bodyText1.color,
                              elevation: 5
                          ),
                          onPressed: (){
                            if( pedidos.length > 0 ){
                              if( _chosenValue == null ){
                                showSnackBarMessage( "Por favor seleccionada un domiciliario" ,  Colors.blue, Icons.warning_amber_outlined, context);
                              }else{
                                print(pedidos[0].numero);
                                print("Reasignar");
                                var accion = ReasignarPedido( pedidos, _chosenValue, context );
                                alertConfirmacion( context, accion, "PedidoBloc", "Reasignar pedido" );
                                //BlocProvider.of<PedidoBloc>(context).add(ReasignarPedido( pedidos, _chosenValue, context ));
                              }
                            }
                            else{
                              showSnackBarMessage( "No hay pedidos para reasignar" ,  Colors.blue, Icons.warning_amber_outlined, context);
                            }
                            },
                          child: Center(
                            child: Row( // Replace with a Row for horizontal icon + text
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Reasignar  ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).backgroundColor,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Icon(
                                  Icons.reply_all_sharp ,
                                  size: 23,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            )
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




