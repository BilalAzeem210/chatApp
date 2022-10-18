import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/chart_screen.dart';
import '../screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundNotificationHandler(RemoteMessage Message) async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("BackgroundMessage : ${Message.data}");
  if(Message.notification != null){
    print("Background Message Notification : ${Message.notification!.body}");
  }
}

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final firebaseapp =  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging Messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((Message) {
    print("Message : ${Message.data}");
    if(Message.notification !=null){
      print('Notifiaction : ${Message.notification!.body}');
    }
  });
  print("inside main:");
  print(firebaseapp.options.appId);
  print(firebaseapp.options.iosClientId);

  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Chat App",
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx,userSnapshot) {
      if(userSnapshot.hasData){
        return ChartScreen();
      }
      return AuthScreen();
      }),
    );

  }
}

