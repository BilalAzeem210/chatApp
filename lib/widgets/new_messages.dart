import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NewMessages extends StatefulWidget {


  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  var _enteredMessage = "";
  void _sendMessage() async{
  final user = await FirebaseAuth.instance.currentUser!;
  final userData = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    FirebaseFirestore.instance.collection('charts').add({
      'text' : _enteredMessage,
      'createdAt' : Timestamp.now(),
      'userId' : user.uid,
      'userImage' : userData['image_url']
    });
    FocusScope.of(context).unfocus();
    _controller.clear();
    _enteredMessage = "";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(child: TextField(
            controller: _controller,
            cursorColor: Color(0xFF0f388a),
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFf20202),),
              ),
              labelStyle: TextStyle(
                color: Color(0xFF0f388a),

              ),
                labelText: "Send a message..."
            ),
            onChanged: (value){
            setState(() {
              _enteredMessage = value;

            });
            },
          ),
          ),
         IconButton(onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage
           , icon: const Icon(Icons.send),
         color: const Color(0xFFf20202),)
        ],
      ),
    );
  }
}
