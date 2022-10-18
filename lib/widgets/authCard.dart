import 'dart:io';

import 'package:flutter/material.dart';

import 'user_image_picker.dart';

class AuthCard extends StatefulWidget {
  AuthCard(this.submitFn,this.isLoading);


  bool isLoading;
  final Future<bool> Function(String email,String password,
      String userName,File? image,bool isLogin,BuildContext ctx) submitFn;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
      _userImageFile = image;
  }
  void _trySubmit() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(_isLogin){
      _formKey.currentState!.save();
      bool status = await widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        null,
        _isLogin,
        context,

      );
      setState(() {
        widget.isLoading = status;
      });
    }
    else if(isValid && _userImageFile != null){
      print("try subMit");
      print(_userImageFile);

      _formKey.currentState!.save();
      bool status = await widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogin,
        context,

      );
      setState(() {
        widget.isLoading = status;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Please Pick An Image'),
        backgroundColor: Theme.of(context).errorColor,

      ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin)
                  UserImagePicker(_pickedImage),
                  if(_isLogin)
                 const Text('Log In',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Pacifico',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0f388a),
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value){
                      if(value!.isEmpty || !value.contains('@')){
                        return 'Please enter a valid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Emailaddress',
                    ),
                    onSaved: (value){
                      _userEmail = value!;
                    },
                  ),
                  if(!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value){
                      if(value!.isEmpty || value.length < 4){
                        return 'Please Enter at least 4 characters';
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Username'
                    ),
                    onSaved: (value){
                      _userName = value!;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value){
                      if(value!.isEmpty || value.length < 6){
                        return 'Please Enter at least 6 characters long.';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value){
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.isLoading ? CircularProgressIndicator() :
                  ElevatedButton(onPressed: _trySubmit,
                    child: Text(_isLogin ? 'LogIn' : 'SignUp',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Pacifico'
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0f388a),
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),

                  TextButton(onPressed: (){
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                    child: Text(_isLogin ? 'Create new account? Sign Up' : 'I have already an account',
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF0f388a),
                          fontFamily: 'Pacifico'
                      ),),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


