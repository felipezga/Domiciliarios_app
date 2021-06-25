import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/widgets/Scanner.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EscanearFactura extends StatelessWidget {

  static const String route = '/escaneo';
  final String arguments;

  EscanearFactura( this.arguments );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("ESCANEAR " + arguments);

    return EscanearScreen(opcion : arguments);
  }
}

class EscanearScreen extends StatefulWidget {

  EscanearScreen({Key key, this.opcion}) : super(key: key);

  final String opcion;

  @override
  _EscanearState createState() => _EscanearState();
}

class _EscanearState extends State<EscanearScreen> {
  //

  String opc;

  @override
  void initState() {
    print("ini");
    super.initState();

    opc = widget.opcion;
    print('Este es: ');
    print(opc);

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
            'ESCANER',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, '/escaner'),
        body: Container(
          child: Center(
            child: Scanner(opcion: opc,)
            /*ElevatedButton(
                child: Text('Scan'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scanner()),
                  );
                }),*/
          ),
        ),
      );
    });
  }



}




