//SHA1:      94:25:3F:81:4D:23:71:AD:24:62:A2:98:64:C7:98:63:EA:48:65:F5

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService{
  // la configuración del proyecto para el messaging
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = new StreamController.broadcast(); // por si hay más de un punto de suscripción (no debería)
  static Stream<String> get messagesStream => _messageStream.stream;  //solo expongo el stream y la gente se puede suscribir a él


  static Future<void> _backgroundHandler( RemoteMessage message ) async {
     print("onbackground handler ${ message.messageId }");
//     _messageStream.sink.add( message.notification?.title ??"" );
      print( message.data );
//     _messageStream.sink.add( message.notification?.body ??"" );     
     _messageStream.add( message.data['producto'] ?? 'No data');

  }

  static Future<void> _onMessageHandler( RemoteMessage message ) async {
     print("onMessage handler ${ message.messageId }");
     print( message.data);
//     _messageStream.sink.add( message.notification?.title ??"" );
     //_messageStream.sink.add( message.notification?.body ??"" );     
     _messageStream.add( message.data['producto'] ?? 'No data');

     
  }
  
  static Future<void> _onMessageOpenHandler( RemoteMessage message ) async {
     print("onMessageOpen handler ${ message.messageId }");
     print( message.data);
//     _messageStream.sink.add( message.notification?.title ??"" );
     //_messageStream.sink.add( message.notification?.body ??"" );     
     _messageStream.add( message.data['producto'] ?? 'No data');
     
  }

  static Future initializeApp() async {
     
     //push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print (token);

    //handlers
    FirebaseMessaging.onBackgroundMessage( _backgroundHandler  );
    FirebaseMessaging.onMessage.listen( _onMessageHandler );
    FirebaseMessaging.onMessageOpenedApp.listen ( _onMessageOpenHandler );

     // local notifications

  }

  static closeStream(){
    _messageStream.close();
  }

}