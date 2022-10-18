
import '../widgets/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat',style: TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 20,
        ),),
        backgroundColor: const Color(0xFF0f388a),
        actions: [
          DropdownButton(underline: Container() ,icon:const Icon(
            Icons.more_vert,
            color: Colors.white,

          ),
            items: [
              DropdownMenuItem(child: Container(child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app,color: Color(0xFF0f388a),),

                  SizedBox(width: 8,),

                  Text('logout',style: TextStyle(
                      fontFamily: 'Pacifico'
                  ),),
                ],
              ),),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if(itemIdentifier == 'logout'){
                FirebaseAuth.instance.signOut();

              }
            },),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Message(),
            ),
            NewMessages(),
          ],
        ),
      ),

    );
  }
}



