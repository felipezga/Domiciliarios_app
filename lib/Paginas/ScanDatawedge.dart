import 'dart:async';
import 'dart:convert';
import 'package:domiciliarios_app/Bloc/EscaneoBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/ArgumentsModel.dart';
import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/widgets/EscanerWidgets.dart';
import 'package:domiciliarios_app/widgets/ListaOrdenesEscaneadas.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ScannerLaser extends StatelessWidget {

  static String route = "ScanOrden";

  final Arguments opcion;

  ScannerLaser(this.opcion ) : super();

  @override

  //static const String route = '/escaneo';
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => EscaneoBloc(),
      child: ScanOrden( opcion : opcion ),
    );
  }
}


class ScanOrden extends StatefulWidget {

  ScanOrden({Key key, this.opcion}) : super(key: key);
  final Arguments opcion;

 // ScanOrden({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScanOrden> {

  String opc;
  List<Orden> ordenes = [];

  static const MethodChannel methodChannel = MethodChannel('com.example.domiciliarios_app/command');
  static const EventChannel scanChannel = EventChannel('com.example.domiciliarios_app/scan');

  //  This example implementation is based on the sample implementation at
  //  https://github.com/flutter/flutter/blob/master/examples/platform_channel/lib/main.dart
  //  That sample implementation also includes how to return data from the method
  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson = jsonEncode({"command": command, "parameter": parameter});

      await methodChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  Future<void> _createProfile(String profileName) async {
    try {
      print("que pasar");
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  String _barcodeString = "";
  String _barcodeSymbology = "Para escanear el codigo QR mantener presionado el boton ESCANEAR o presionar suavemente para dejar el laser activado";
  //String _scanTime = "Scan Time will be shown here";

  @override
  void initState() {
    super.initState();

    print("vamos");
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

  void _onEvent(Object event) {
    print("On event");
    Map barcodeScan = jsonDecode(event);
    _barcodeString = barcodeScan['scanData'];

    BlocProvider.of<EscaneoBloc>(context).add(EscaneandoEvent(_barcodeString, opc, ordenes ));
    /*setState(() {
      Map barcodeScan = jsonDecode(event);
      _barcodeString = "Barcode: " + barcodeScan['scanData'];
      _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
      _scanTime = "At: " + barcodeScan['dateTime'];
    });*/
  }

  void _onError(Object error) {
    /*setState(() {
      _barcodeString = "Barcode: error";
      _barcodeSymbology = "Symbology: error";
      _scanTime = "At: error";
    });*/
  }

  void startScan() {
    //setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
    //});
  }

  void stopScan() {
    //setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING");
    //});
  }

  @override
  Widget build(BuildContext context) {


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
            'ESCANEAR ORDEN',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, '/ScanOrden'),
        body: Container(
          //color: Colors.orange,
          child: Center(
              child: ScannerLaserOrder()
          ),
        ),
      );
    });

  }

  ScannerLaserOrder(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            //color: Colors.grey,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //color: Colors.pink,
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '$_barcodeSymbology',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTapDown: (TapDownDetails) {
              startScan();
              },
            onTapUp: (TapUpDetails) {
              stopScan();
              },
            // The custom button
            child: Container(
                margin: EdgeInsets.all(30.0),
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Row(
                    // Replace with a Row for horizontal icon + text
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("ESCANEAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            //color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Icon(
                        Icons.qr_code_scanner ,
                        size: 30,
                        //color: Theme.of(context).backgroundColor
                        ),
                    ],
                  ),
                )
            ),
          ),
          SizedBox(
            height: 120,
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
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          CardScan(message, Colors.yellow[300]),
                          SizedBox(height: 10),
                          //Divider(color: Theme.of(context).backgroundColor,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes, "laser"  ),
                              ButtonScan(context, "Ordenes", Icons.list, ordenes, "laser"),
                            ],
                          )
                        ],
                      );
                    }
                    if (state is ErrorAgregar) {
                      String message = state.error;
                      ordenes = state.listOrdenes;

                      return  ListView(
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          CardScan(message, Colors.red[400]),
                          SizedBox(height: 10),
                          //Divider(color: Theme.of(context).backgroundColor,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes , "laser" ),
                              ButtonScan(context, "Ordenes", Icons.list, ordenes, "laser"),
                            ],
                          )
                        ],
                      );
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
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          CardScan(state.respuesta +' '+texto +' EXITOSAMENTE  ', Colors.green[400]),
                          SizedBox(height: 10),
                          //Divider(color: Theme.of(context).backgroundColor,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes , "laser" ),
                              ButtonScan(context, "Ordenes", Icons.list, ordenes, "laser"),
                            ],
                          )
                        ],
                      );
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
                  }
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
