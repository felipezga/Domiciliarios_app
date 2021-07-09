

import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineDelivery extends StatelessWidget {
  final List<EstadoDomiciliario> estaDomiTL;
  TimelineDelivery( this.estaDomiTL );


  @override
  Widget build(BuildContext context) {

    print("tiemlinee");
    print(estaDomiTL.length);
    EstadoDomiciliario a;
    bool bandPreparado = false;
    Color colorPreparado = Color(0xFFDADADA);
    String horaPreparado ="";

    bool bandIniciar = false;
    Color colorIniciar = Color(0xFFDADADA);
    String horaIniciarTL ="";

    bool bandFinalizar = false;
    Color colorFinalizar = Color(0xFFDADADA);
    String horaFinalizarTL ="";


    if(estaDomiTL.length > 0){
      for(  a in estaDomiTL){
        print("aaaaa");
        print(a.estado);
        if (a.estado == "PREPARADO"){
          bandPreparado = true;
          horaPreparado = a.hora;
          colorPreparado =  bandPreparado == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }
        if (a.estado == "INICIAR"){
          bandIniciar = true;
          horaIniciarTL = a.hora;
          colorIniciar =  bandIniciar == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }
        if (a.estado == "FINALIZAR"){
          bandFinalizar = true;
          horaFinalizarTL = a.hora;
          colorFinalizar =  bandFinalizar == true? Color(0xFF27AA69) : Color(0xFFDADADA);

        }

      }

      return Container(
        //height: 45,
        //width: 30,
        //decoration: BoxDecoration(color: Colors.red,),
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: bandPreparado == true? Icons.check : Icons.lock_outline_rounded , fontSize: 15 ),
                color: colorPreparado,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                asset: 'images/preparado.png',
                title: 'PRODUCTO PREPARADO',
                message: horaPreparado,
                disabled: !bandPreparado,
              ),
              beforeLineStyle:  LineStyle(
                color: colorPreparado,
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: bandIniciar == true? Icons.check : Icons.lock_outline_rounded , fontSize: 16 ),
                color: colorIniciar,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                disabled: !bandIniciar,
                asset: 'images/domiciliario.png',
                title: 'INICIAR ENTREGA',
                message: horaIniciarTL,
              ),
              beforeLineStyle:  LineStyle(
                color: colorIniciar,
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              indicatorStyle:  IndicatorStyle(
                width: 20,
                iconStyle: IconStyle( color: Colors.white, iconData: bandFinalizar == true? Icons.check : Icons.lock_outline_rounded , fontSize: 15 ),
                color: colorFinalizar,
                padding: EdgeInsets.all(6),
              ),
              endChild:  _RightChild(
                disabled: !bandFinalizar,
                asset: 'images/entregado.png',
                title: 'PEDIDO ENTREGADO',
                message: horaFinalizarTL,
              ),
              beforeLineStyle:  LineStyle(
                color: colorFinalizar,
              ),
              //afterLineStyle:  LineStyle(
              //  color: Color_finalizar,
              //),
            ),

          ],
        ),
      );


    }else{
      return Container(
        //height: 45,
        //width: 30,
        //decoration: BoxDecoration(color: Colors.red,),
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFFDADADA),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                asset: 'images/frisby.png',
                title: 'PEDIDO PROCESADO',
                message: '',
                disabled: true,
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF27AA69),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/domiciliario.png',
                title: 'INICIAR ENTREGA ',
                message: '',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFF2B619C),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/entregado.png',
                title: 'PEDIDO ENTREGADO',
                message: 'Disfruta tu pedido',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF27AA69),
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                color: Color(0xFFDADADA),
                padding: EdgeInsets.all(6),
              ),
              endChild: const _RightChild(
                disabled: true,
                asset: 'images/frisby.png',
                title: 'Ready to Pickup',
                message: 'Your order is.',
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
              ),
            ),
          ],
        ),
      );
    }



  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: disabled ?  const Color(0xFFBABABA)
                      :  Theme.of(context).textTheme.bodyText1.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                /*style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),*/
              ),
              const SizedBox(height: 6),
              Row(children: [
                !disabled?  Icon( Icons.timer_outlined) : Text(""),
                Text(
                  message,
                  style: TextStyle(
                    color: disabled ?  const Color(0xFFBABABA)
                        :  Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  /*style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),*/
                ),
              ],)

            ],
          ),
        ],
      ),
    );
  }
}
