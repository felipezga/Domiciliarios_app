import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'package:restaurantes_tipoventas_app/widgets/drawer.dart';

import 'Mapa.dart';
//import 'Restaurante.dart';

class PaginaHome extends StatelessWidget{
  static const String route = '/';
  const PaginaHome({Key key}) : super(key: key);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text(
              " APP DOMICILIARIOS",
              style: TextStyle(
                  fontSize: 25,
                  //color: Theme.of(context).primaryColor,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              )
          ),
          //backgroundColor: Colors.yellow
      ),
      drawer: buildDrawer(context, route),
      body:
      //HomePage()
      Mapa(),


          //backgroundColor:Colors.green[700],
          /*bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              _paginaActual = index;
            });
          },
          currentIndex: _paginaActual,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Restaurante"),
          ],
        ),*/
    );

  }

}

class Empresa extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("EMPRESA"),),
      body: Center(
        child: Text("SECCIÓN EMPRESA"),
      ),
    );
  }
}

/*
class Productos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("PRODUCTOS"),),
      body: Center(
        child: Text("SECCIÓN PRODUCTOS"),
      ),
    );
  }
}*/
class Contacto extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("CONTACTO"),),
      body: Center(
        child: Text("SECCIÓN CONTACTO"),
      ),
    );
  }
}


PushNotification _notificationInfo;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


Future<dynamic> _firebaseMessagingBackgroundHandler(
    Map<String, dynamic> message,
    ) async {
  // Initialize the Firebase app
  await Firebase.initializeApp();
  print('onBackgroundMessage received: $message');
}


class _HomePageState extends State<HomePage> {
  int _totalNotifications;
  //FirebaseMessaging _messaging = FirebaseMessaging();
  FirebaseMessaging _messaging = FirebaseMessaging();



  void registerNotification() async {

    print("Empezo esto");
    // Initialize the Firebase app
    await Firebase.initializeApp();

    // On iOS, this helps to take the user permissions
    await _messaging.requestNotificationPermissions(
      IosNotificationSettings(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      ),
    );

    // For handling the received notifications
    _messaging.configure(
      onMessage: (message) async {
        print('onMessage received: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        // For displaying the notification as an overlay
        showSimpleNotification(
          Text(_notificationInfo.title),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_notificationInfo.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
        );
      },
      onBackgroundMessage: _firebaseMessagingBackgroundHandler,
      onLaunch: (message) async {
        print('onLaunch: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
      onResume: (message) async {
        print('onResume: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
    );

    // Used to get the current FCM token
    _messaging.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print("que maricada ser gay");
      print(e);
    });
  }

  void initState() {
    _totalNotifications = 0;
    registerNotification();
    super.initState();

    /*
    final NotificacionServicio = new NotificacionesPush();
    NotificacionServicio.initNotification();
     */
  }

  @override
  Widget build(BuildContext context) {

    //return Scaffold(
      /*appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),*/
      //body:
       return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'App for capturing Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 10.0),
          _notificationInfo != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TITLE: ${_notificationInfo.title ?? _notificationInfo.dataTitle}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BODY: ${_notificationInfo.body ?? _notificationInfo.dataBody}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          )
              : Container(),
        ],
      );
    //);


  }
  }

  class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({@required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
  return Container(
  width: 40.0,
  height: 40.0,
  decoration: new BoxDecoration(
  color: Colors.red,
  shape: BoxShape.circle,
  ),
  child: Center(
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text(
  '$totalNotifications',
  style: TextStyle(color: Colors.white, fontSize: 20),
  ),
  ),
  ),
  );
  }
  }

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json["notification"]["title"],
      body: json["notification"]["body"],
      dataTitle: json["data"]["title"],
      dataBody: json["data"]["body"],
    );
  }
}


