import 'package:firebasechartapp/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('charts').orderBy('createdAt',descending: true).snapshots(),
    builder: (ctx, chatSnapshot) {
      if(chatSnapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator(),);
      }
      final chatDocs = chatSnapshot.data!.docs;
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("charts").orderBy("createdAt").snapshots(),
          builder: (ctx,futureSnapshot) {
            if(futureSnapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
             return MessageBubble(chatDocs[index]['text'],
            chatDocs[index]['userId'],
            chatDocs[index]['userImage'],
          );
          }
          );
          });
    },);
  }
}
