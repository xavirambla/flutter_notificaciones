import 'package:flutter/material.dart';
import 'package:notificaciones/screens/screens.dart';
import 'package:notificaciones/services/push_notifications_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();  // Provoca que tengamos ya un contexto en el ssitema. Sino puede fallar nuestra app
  await PushNotificationsService.initializeApp();

  runApp(MyApp());
}
 

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();


@override
void initState() {
  super.initState();
  
  //Context
  // le decimos a la app que siempre esté escuchando por si recibimos alguna notificación
  PushNotificationsService.messagesStream.listen(( message) {
    print ("MyApp: $message");
    
    // para mostrar un snackbar
    final snackBar = SnackBar(content: Text( message ) );    
    messengerKey.currentState?.showSnackBar(snackBar);

    // para navegar a una pagina 
    navigatorKey.currentState?.pushNamed('message', arguments: message);

   });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      navigatorKey:  navigatorKey,//navegar
      scaffoldMessengerKey:  messengerKey,//snacks
      routes:{
        'home': ( _ ) => HomeScreen(),  
        'message': ( _ ) => MessageScreen(),
      }
    
 
    );
  }
}


/*
android/app/build.gradle     Cambiar applicationId   

com.example.notificaciones  copiamos
control+Shift + F     y buscamos el texto para reemplazarloo

app/src/main/kotlin
Cambiamos también la carpeta
 */