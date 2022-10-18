import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {

  MessageBubble(this.message,this.userId,this.userImage);

  final String message;
  final String userImage;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
        mainAxisAlignment: FirebaseAuth.instance.currentUser!.uid == userId ? MainAxisAlignment.end : MainAxisAlignment.start,
         children: [
           Container(
            decoration: BoxDecoration(
              color: FirebaseAuth.instance.currentUser!.uid == userId ? const Color(0xFF270136) : const Color(0xFF180138),
                borderRadius: BorderRadius.only(
                  topLeft:const Radius.circular(12),
                  topRight:const Radius.circular(12),
                  bottomLeft: FirebaseAuth.instance.currentUser!.uid != userId ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: FirebaseAuth.instance.currentUser!.uid == userId ? const Radius.circular(0) : const Radius.circular(12),
                ),
            ),
            width: 135,

            padding: const EdgeInsets.symmetric(vertical: 10,
                horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 15,
            horizontal: 8),
            child: Column(
              crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == userId ? CrossAxisAlignment.start : CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Text('Loading...',style: TextStyle(color: Colors.white),);
                    }
                    return Text(snapshot.data!['username'],style:const TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.white),
                      textAlign: FirebaseAuth.instance.currentUser!.uid == userId ? TextAlign.end : TextAlign.end,
                    );

                  }
                ),
                Text(message ,style: TextStyle(
                color: FirebaseAuth.instance.currentUser!.uid == userId ? const Color(0xFFdefaf8) : const Color(0xFFFAFCFA),
              ),),
              ],
            ),
      ),
         ],

    ),
          Positioned(
            top: -5,
          left: FirebaseAuth.instance.currentUser!.uid == userId ? null : 120,
          right: FirebaseAuth.instance.currentUser!.uid == userId ? 120 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),

          ),

        ],


    );
  }
}
