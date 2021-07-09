import 'dart:async';

import 'package:domiciliarios_app/Bloc/EscaneoBloc.dart';
import 'package:domiciliarios_app/Modelo/ArgumentsModel.dart';
import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'ListaOrdenesEscaneadas.dart';
import 'Loading.dart';


class Scanner extends StatelessWidget {

  final Arguments opcion;

  Scanner({ Key key,    this.opcion }) : super(key: key);

  @override

  //static const String route = '/escaneo';
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => EscaneoBloc(),
      child: ScannerScreen( opcion : opcion ),
    );
  }
}


class ScannerScreen extends StatefulWidget {

  ScannerScreen({Key key, this.opcion}) : super(key: key);


  final Arguments opcion;


  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerScreen> {

  String opc;
  List<Orden> ordenes = [];

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String result = "";

  @override
  Widget build(BuildContext context) {

    opc = widget.opcion.message;
    ordenes = widget.opcion.ordenes;
    print('Este es: ' + opc);

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Stack(
      key: _scaffoldKey,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                            borderColor: Colors.red,
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: scanArea),
                      ),
                      /*Center(
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )*/
                    ],
                  ),
                ),

                SizedBox(
                    height: 100,
          //flex: 1,
          child:
            Center(
            child:
                BlocBuilder<EscaneoBloc, EscaneoState>(
                    builder: (BuildContext context, EscaneoState state) {

                      if(state is EscaneoAsignado){
                        Timer(Duration(seconds: 3), () {
                          print("Yeah, this line is printed after 3 seconds");
                          Navigator.popAndPushNamed(context, '/mapa');
                          });

                      }
                      if (state is EscaneoExistente) {
                        ordenes = state.listOrdenes;
                        String message = '${state.asignacion}';

                        return  ListView(
                          padding: const EdgeInsets.all(7),
                          children: <Widget>[
                            Card(
                              color: Colors.blue,
                              child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(message, style: TextStyle(
                                            fontSize: 13,
                                            //color: Colors.white,
                                            fontWeight: FontWeight.w600
                                        )),
                                        /*Icon( Icons.check_circle_outline , size: 20,
                                          //color: Colors.red,
                                        )*/
                                      ]
                                  )
                              ),
                            ),
                            SizedBox(height: 3),
                            //Divider(color: Theme.of(context).backgroundColor,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).textTheme.bodyText1.color, // background
                                      onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                      elevation: 5// foreground
                                  ),
                                  onPressed: (){
                                    //Navigator.popAndPushNamed(context, '/escaner');
                                    Navigator.popAndPushNamed(context, EscanearFactura.route, arguments:  Arguments("asignar", ordenes ) );
                                  },
                                  //width: 90,
                                  //height: 40,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Escanear   ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context).backgroundColor,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        Icon( Icons.qr_code_scanner , size: 23, color: Theme.of(context).backgroundColor,),
                                      ],
                                    ),
                                  ),

                                ),
                                /*ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).textTheme.bodyText1.color, // background
                                      onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                      elevation: 5// foreground
                                  ),
                                  onPressed: (){
                                    Navigator.popAndPushNamed(context, '/mapa');
                                  },
                                  //width: 90,
                                  //height: 40,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Entregar   ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context).backgroundColor,
                                              fontWeight: FontWeight.w900
                                          ),
                                        ),
                                        Icon( Icons.assignment_turned_in_outlined  , size: 23, color: Theme.of(context).backgroundColor,),
                                      ],
                                    ),
                                  ),

                                ),*/

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).textTheme.bodyText1.color, // background
                                      onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                      elevation: 5// foreground
                                  ),
                                  onPressed: (){
                                    //Navigator.popAndPushNamed(context, '/mapa');
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext cont) {
                                          return AlertDialog(
                                              title: Text('Ordenes Escaneadas'),
                                              content: setupAlertDialoadContainer( ordenes ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text("Enviar"),
                                                  onPressed: () {
                                                    BlocProvider.of<EscaneoBloc>(context).add(AsignarPedido(ordenes, context));
                                                    Navigator.of(cont).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text("Cerrar"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),

                                              ]
                                          );
                                        });
                                  },
                                  //width: 90,
                                  //height: 40,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Ordenes   ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context).backgroundColor,
                                              fontWeight: FontWeight.w900
                                          ),
                                        ),
                                        //Icon( Icons.assignment_turned_in_outlined  , size: 23, color: Theme.of(context).backgroundColor,),
                                        Icon( Icons.list  , size: 23, color: Theme.of(context).backgroundColor,),

                                      ],
                                    ),
                                  ),

                                ),
                              ],)
                          ],

                        );


                        /*return
                          Container(
                            padding: EdgeInsets.all(5.0),
                            color: Colors.red,
                            child: Center(
                              child: Row( // Replace with a Row for horizontal icon + text
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon( Icons.error , size: 25,
                                    //color: Colors.red,
                                  ),
                                  Text(message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //color: Colors.red,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );*/


                        //showInSnackBar('Error:');
                        /*ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:Text("Pedido: "+message +" asignado con exito!",
                              textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                              FontWeight.bold),),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );*/

                      }

                      if (state is EscaneoError) {
                        final error = state.error;
                        //String message = '${error.message}';
                        print(error);

                        return
                          Container(
                              padding: EdgeInsets.all(5.0),
                              color: Colors.red,
                              child: Center(
                                  child:
                                  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                          Expanded(
                          child: Text(
                              "Por favor volver a escanear el codigo, si el error persiste comunicarse con su jefe\n "
                                  //+ message
                          ),
                      ),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, EscanearFactura.route, arguments:  opc, );
                                  },
                                  child: Icon(Icons.qr_code_scanner_sharp, color: Colors.white),
                                  style: ElevatedButton.styleFrom(

                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(10),
                                    primary: Colors.black, // <-- Button color
                                    onPrimary: Colors.red, // <-- Splash color
                                  ),
                                ),

                      ],
                                  )
                              )
                                  );
                          /*Container(
                            padding: EdgeInsets.all(5.0),
                            color: Colors.red,
                            child: Center(
                              child: Row( // Replace with a Row for horizontal icon + text
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon( Icons.error , size: 20,
                                    //color: Colors.red,
                                  ),
                              Text(message),
                                  /*Text(message + "\n Por favor volver a escaneo el codigo o comunicarse con su jefe",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //color: Colors.red,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),*/

                                ],
                              ),
                            ),
                          );*/

                      }

                      if (state is EscaneoCompletado) {
                        String texto = "";
                        ordenes = state.listOrdenes;


                        if (opc == "entregar"){
                          texto = "ENTREGADO";

                        }else{
                          texto = "ASIGNADO";
                        }

                        return  ListView(
                          padding: const EdgeInsets.all(7),
                          children: <Widget>[
                            Card(
                              color: Colors.green,
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(state.respuesta +' '+texto +' EXITOSAMENTE  ', style: TextStyle(
                                            fontSize: 15,
                                            //color: Colors.white,
                                            fontWeight: FontWeight.w600
                                        )),
                                        /*Icon( Icons.check_circle_outline , size: 20,
                                //color: Colors.red,
                              )*/
                                      ]
                                  )

                              ),
                            ),
                            SizedBox(height: 3),
                            //Divider(color: Theme.of(context).backgroundColor,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).textTheme.bodyText1.color, // background
                                      onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                      elevation: 5// foreground
                                  ),

                                  onPressed: (){
                                    //Navigator.popAndPushNamed(context, '/escaner');
                                    Navigator.popAndPushNamed(context, EscanearFactura.route, arguments: Arguments("asignar", ordenes ), );
                                  },
                                  //width: 90,
                                  //height: 40,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Escanear   ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context).backgroundColor,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        Icon( Icons.qr_code_scanner , size: 23, color: Theme.of(context).backgroundColor,),
                                      ],
                                    ),
                                  ),

                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).textTheme.bodyText1.color, // background
                                      onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                      elevation: 5// foreground
                                  ),
                                  onPressed: (){
                                    //Navigator.popAndPushNamed(context, '/mapa');
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext cont) {
                                          return AlertDialog(
                                              title: Text('Ordenes Escaneadas'),
                                              content: setupAlertDialoadContainer( ordenes ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text("Enviar"),
                                                  onPressed: () {
                                                    BlocProvider.of<EscaneoBloc>(context).add(AsignarPedido(ordenes, context));
                                                    Navigator.of(cont).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text("Cerrar"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),

                                              ]
                                          );
                                        });
                                  },
                                  //width: 90,
                                  //height: 40,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Ordenes   ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context).backgroundColor,
                                              fontWeight: FontWeight.w900
                                          ),
                                        ),
                                        //Icon( Icons.assignment_turned_in_outlined  , size: 23, color: Theme.of(context).backgroundColor,),
                                        Icon( Icons.list  , size: 23, color: Theme.of(context).backgroundColor,),

                                      ],
                                    ),
                                  ),

                                ),
                              ],)
                          ],

                        );

                        /*return Container(
                          padding: EdgeInsets.all(5.0),
                          color: Colors.green,
                          child: Column(
                            children: [
                              Text(state.respuesta+' ASIGNADO CORRECTAMENTE', style: TextStyle(
                                  fontSize: 17,
                                  //color: Colors.white,
                                  fontWeight: FontWeight.w600
                              )),
                              SizedBox(height: 4),
                              Divider(color: Theme.of(context).backgroundColor,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).backgroundColor, // background
                                        onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                        elevation: 5// foreground
                                    ),

                                    onPressed: (){
                                      Navigator.popAndPushNamed(context, '/escaner');
                                    },
                                    //width: 90,
                                    //height: 40,
                                    child: Center(
                                      child: Row( // Replace with a Row for horizontal icon + text
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text("Escanear   ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              //color: Colors.white,
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                          Icon( Icons.qr_code_scanner , size: 23,),
                                        ],
                                      ),
                                    ),

                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).backgroundColor, // background
                                        onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                        elevation: 5// foreground
                                    ),
                                    onPressed: (){
                                      Navigator.popAndPushNamed(context, '/mapa');
                                    },
                                    //width: 90,
                                    //height: 40,
                                    child: Center(
                                      child: Row( // Replace with a Row for horizontal icon + text
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Entregar   ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900
                                            ),
                                          ),
                                          Icon( Icons.assignment_turned_in_outlined  , size: 23,),
                                        ],
                                      ),
                                    ),

                                  ),
                                ],)
                            ],
                          ),
                        );*/

                        /*ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:Text("Pedido: "+state.respuesta +" asignado con exito!",
                              textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                              FontWeight.bold),),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3),
                          ),
                        );*/
                        //
                      }

                      if (state is Escaneando) {
                        return Loading();
                      }else{

                        String texto= "";
                        print("Llegamos aqui");
                        if (opc == "entregar"){
                          texto = "Escanea el codigo QR de la factura para hacer la entrega del pedido";

                        }else{
                          texto = "Escanea el codigo QR de la factura para asignar el pedido";
                        }

                        return Container(
                          padding: EdgeInsets.all(15.0),
                            child: Text( texto ,
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  //color: Colors.white,
                                  fontWeight: FontWeight.w600
                              ),
                            )
                        );

                      }

                      /*Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Hello from snackbar",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                            FontWeight.bold),), duration: Duration(seconds: 3), backgroundColor: Colors.blue,)
                      );*/



                      //return Loading();


                    }
                      ),
          ),

        )




              ],
            ),
          ],

    );
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print("la data");
      print(scanData);

      controller.pauseCamera();

      //context.read<EscaneoBloc>().add(EscaneandoEvent());
      print(opc);
      BlocProvider.of<EscaneoBloc>(context).add(EscaneandoEvent(scanData.code, opc, ordenes ));






      /*setState(() {
        result = scanData.code;
      });*/


      /*if (await canLaunch(scanData.code)) {
        await launch(scanData.code);
        controller.resumeCamera();

      } else {
        showInSnackBar('Error: ${scanData.code}\n${scanData.code}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Could not find viable url'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Barcode Type: ${describeEnum(scanData.format)}'),
                    Text('Data: ${scanData.code}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((value) => controller.resumeCamera());
      }*/
    });
  }
}