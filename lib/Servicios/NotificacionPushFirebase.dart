import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificacionesPush{
  FirebaseMessaging _messaging = FirebaseMessaging();
  initNotification(){

    // Initialize the Firebase app
    //await Firebase.initializeApp();

    // On iOS, this helps to take the user permissions
    _messaging.requestNotificationPermissions(
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


      },
      onBackgroundMessage: _firebaseMessagingBackgroundHandler,
      onLaunch: (message) async {
        print('onLaunch: $message');

      },
      onResume: (message) async {
        print('onResume: $message');

      },
    );

    /* _messaging.configure(
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
     );*/

    // Used to get the current FCM token
    _messaging.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print("que maricada ser gay");
      print(e);
    });

  }


}

Future<dynamic> _firebaseMessagingBackgroundHandler(Map<String, dynamic> message,) async {
  // Initialize the Firebase app
  await Firebase.initializeApp();
  print('onBackgroundMessage received: $message');
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


