import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/authCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/Auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
 final _auth = FirebaseAuth.instance;
 var _isLoading = false;

  Future<bool> _submitAuthForm(
      String email,
      String password,
      String userName,
      File? image,
      bool isLogin,
      BuildContext ctx,
      ) async{
      UserCredential authResult;
     try {
       setState(() {
         _isLoading = true;
       });
       if (isLogin) {
         authResult = await _auth.signInWithEmailAndPassword(
             email: email, password: password);
       }
       else {
         print("signup");
         print("sig eMail : $email");
         print("sig password : $password");
         authResult = await _auth.createUserWithEmailAndPassword(
             email: email, password: password);


       final ref =  FirebaseStorage.instance.ref().child('user_image').child('${authResult.user!.uid}.jpg');
      final refOne = await ref.putFile(image!).whenComplete((){
        print("iMage uploaded");
       });
       final url = await refOne.ref.getDownloadURL();
       print("IMage url : $url");

       await FirebaseFirestore.instance.collection('user').doc(authResult.user!.uid).set(
           {
             'username' : userName,
             'email' : email,
             'image_url' : url
           });
       }
     }
     on FirebaseAuthException catch (error){
      var message = 'An error occurred, please check your credentials!';

      if(error.message !=null){
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message),
      backgroundColor: Theme.of(ctx).errorColor,));
      setState(() {
        _isLoading = false;
      });
     }
     catch(error){
       print(error);
       setState(() {
         _isLoading = false;
       });
     }
     finally{
       return false;
     }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("0079ff"),
              hexStringToColor("290979"),
              hexStringToColor("111036"),


            ],
            begin: Alignment.topRight, end: Alignment.bottomLeft,
          )
      ),


      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AuthCard(_submitAuthForm,_isLoading),
      ),
    );
  }
}
